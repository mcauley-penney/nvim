-- Commands:
--   :PackFloat      open UI and fetch/check updates
--   :PackFloat!     open UI without fetching, using already fetched refs

local api = vim.api

local M = {}

local ns = api.nvim_create_namespace("pack_float_ui")
local max_commits = 12

local state = {
  bufnr = nil,
  winid = nil,
  autocmd = nil,
  check_timer = nil,
  check_dot_count = 0,
  checking = false,
  check_id = 0,
  status = "",
  plugins = {},
  pending = {},
  clean = {},
  not_loaded = {},
  commits = {},
  expanded = {},
  line_to_name = {},
  name_to_line = {},
}

local function setup_highlights()
  local links = {
    PackFloatTitle = "Title",
    PackFloatBorder = "FloatBorder",
    PackFloatSection = "Label",
    PackFloatPending = "NormalFloat",
    PackFloatClean = "NormalFloat",
    PackFloatMuted = "Comment",
    PackFloatHash = "Number",
    PackFloatKey = "Function",
    PackFloatError = "DiagnosticError",
  }
  for group, link in pairs(links) do
    api.nvim_set_hl(0, group, { link = link, default = true })
  end
end

local function valid_window()
  return state.winid and api.nvim_win_is_valid(state.winid)
end

local function valid_buffer()
  return state.bufnr and api.nvim_buf_is_valid(state.bufnr)
end

local function plugin_at_cursor()
  if not valid_window() then return nil end
  local row = api.nvim_win_get_cursor(state.winid)[1]
  return state.line_to_name[row]
end

local function split_lines(text)
  local lines = {}
  for line in (text or ""):gmatch("[^\n]+") do
    lines[#lines + 1] = line
  end
  return lines
end

local function short_rev(rev) return rev and rev:sub(1, 8) or "unknown" end

local function is_pending(plugin)
  return plugin.rev and plugin.rev_to and plugin.rev ~= plugin.rev_to
end

local function sort_by_name(items)
  table.sort(items, function(a, b) return a.spec.name < b.spec.name end)
end

local function set_plugins(plugins)
  state.plugins = plugins
  state.pending = {}
  state.clean = {}
  state.not_loaded = {}

  for _, plugin in ipairs(state.plugins) do
    local pending = is_pending(plugin)
    if pending then
      state.pending[#state.pending + 1] = plugin
    elseif plugin.active then
      state.clean[#state.clean + 1] = plugin
    else
      state.not_loaded[#state.not_loaded + 1] = plugin
    end
  end

  sort_by_name(state.plugins)
  sort_by_name(state.pending)
  sort_by_name(state.clean)
  sort_by_name(state.not_loaded)
end

local function replace_plugin(plugin)
  local name = plugin.spec.name
  for i, existing in ipairs(state.plugins) do
    if existing.spec.name == name then
      state.plugins[i] = plugin
      set_plugins(state.plugins)
      return
    end
  end

  state.plugins[#state.plugins + 1] = plugin
  set_plugins(state.plugins)
end

local function reset_data()
  state.plugins = {}
  state.pending = {}
  state.clean = {}
  state.not_loaded = {}
  state.commits = {}
  state.expanded = {}
  state.line_to_name = {}
  state.name_to_line = {}
end

local function load_fast_plugin_list()
  local ok, plugins_or_err = pcall(vim.pack.get, nil, { info = false })
  if ok then
    set_plugins(plugins_or_err)
    return
  end
  state.status = tostring(plugins_or_err)
end

local render

local function stop_check_animation()
  if state.check_timer then
    state.check_timer:stop()
    state.check_timer:close()
    state.check_timer = nil
  end
  state.check_dot_count = 0
end

local function start_check_animation()
  stop_check_animation()
  state.check_dot_count = 1
  state.check_timer = vim.uv.new_timer()
  state.check_timer:start(350, 350, function()
    vim.schedule(function()
      if not state.checking or not valid_buffer() then return end
      state.check_dot_count = state.check_dot_count % 3 + 1
      render()
    end)
  end)
end

local function set_lines(lines, hls)
  if not valid_buffer() then return end

  vim.bo[state.bufnr].modifiable = true
  api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].modified = false

  api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
  for _, hl in ipairs(hls) do
    api.nvim_buf_set_extmark(state.bufnr, ns, hl[1], hl[2], {
      end_col = hl[3],
      hl_group = hl[4],
    })
  end
end

local function build_content()
  local lines = {}
  local hls = {}
  local line_to_name = {}
  local name_to_line = {}

  local function add(text, hl)
    local row = #lines
    lines[#lines + 1] = text
    if hl then hls[#hls + 1] = { row, 0, #text, hl } end
    return row
  end

  local function add_hl(row, start_col, end_col, hl)
    hls[#hls + 1] = { row, start_col, end_col, hl }
  end

  local function mark_plugin(row, name)
    line_to_name[row + 1] = name
    name_to_line[name] = name_to_line[name] or row + 1
  end

  add("")

  local help =
    " [r] refresh  [u] update  [U] update all  [x] uninstall  [Enter] details  [q] close"
  local help_row = add(help)
  for start_pos, end_pos in help:gmatch("()%b[]()") do
    add_hl(help_row, start_pos - 1, end_pos - 1, "PackFloatKey")
  end

  add("")

  local plugin_indent = "   "
  local detail_indent = "     "

  local function format_version(version)
    if version == nil then return "default branch" end
    return tostring(version)
  end

  local function split_commit(commit)
    local hash, rest = tostring(commit or ""):match("^(%x+)%s*(.*)$")
    if not hash then return tostring(commit or ""), "" end

    return hash, rest
  end

  local function conventional_prefix_len(message)
    return message:match("^[%w_-]+%b()!:") and #message:match("^[%w_-]+%b()!:")
      or message:match("^[%w_-]+%b():") and #message:match("^[%w_-]+%b():")
      or message:match("^[%w_-]+!:") and #message:match("^[%w_-]+!:")
      or message:match("^[%w_-]+:") and #message:match("^[%w_-]+:")
      or nil
  end

  local function add_plugin(plugin, pending)
    local name = plugin.spec.name
    local commits = state.commits[name]
    local line = plugin_indent .. name
    local revision = pending and ("%s → %s"):format(
      short_rev(plugin.rev),
      short_rev(plugin.rev_to)
    ) or short_rev(plugin.rev)

    local row = add(line)
    mark_plugin(row, name)

    local name_start = #plugin_indent
    add_hl(
      row,
      name_start,
      name_start + #name,
      pending and "PackFloatPending" or "PackFloatClean"
    )
    if state.expanded[name] then
      add(
        (detail_indent .. "path      %s"):format(plugin.path),
        "PackFloatMuted"
      )
      mark_plugin(#lines - 1, name)
      add(
        (detail_indent .. "src       %s"):format(plugin.spec.src),
        "PackFloatMuted"
      )
      mark_plugin(#lines - 1, name)
      add(
        (detail_indent .. "version   %s"):format(
          format_version(plugin.spec.version)
        ),
        "PackFloatMuted"
      )
      mark_plugin(#lines - 1, name)
      add(
        (detail_indent .. "revision  %s"):format(revision),
        "PackFloatMuted"
      )
      mark_plugin(#lines - 1, name)
      if not pending then
        add("", "PackFloatMuted")
        mark_plugin(#lines - 1, name)
      end
    end

    if pending then
      if state.expanded[name] then
        add("", "PackFloatMuted")
        mark_plugin(#lines - 1, name)
      end

      if commits == nil then
        add(detail_indent .. "commits: loading...", "PackFloatMuted")
        mark_plugin(#lines - 1, name)
      elseif #commits == 0 then
        add(
          detail_indent .. "commits: no new commits found",
          "PackFloatMuted"
        )
        mark_plugin(#lines - 1, name)
      else
        local limit = math.min(#commits, max_commits)
        for i = 1, limit do
          local commit = commits[i]
          local hash, message = split_commit(commit)
          local commit_line = message ~= ""
              and (detail_indent .. "%s  %s"):format(hash, message)
            or (detail_indent .. hash)
          local commit_row = add(commit_line)
          mark_plugin(commit_row, name)
          if hash:match("^%x+$") then
            add_hl(
              commit_row,
              #detail_indent,
              #detail_indent + #hash,
              "PackFloatHash"
            )
          end
          local prefix_len = conventional_prefix_len(message)
          if prefix_len then
            local start_col = #detail_indent + #hash + 2
            add_hl(
              commit_row,
              start_col,
              start_col + prefix_len,
              "PackFloatKey"
            )
          end
        end
        if #commits > limit then
          add("", "PackFloatMuted")
          mark_plugin(#lines - 1, name)
          add(
            (detail_indent .. "... %d more"):format(#commits - limit),
            "PackFloatMuted"
          )
          mark_plugin(#lines - 1, name)
        end
      end

      add("", "PackFloatMuted")
      mark_plugin(#lines - 1, name)
    end
  end

  add((" Updates (%d)"):format(#state.pending), "PackFloatSection")
  if #state.pending == 0 then
    add(
      state.checking and "   checking..." or "  no pending updates",
      "PackFloatMuted"
    )
  else
    for _, plugin in ipairs(state.pending) do
      add_plugin(plugin, true)
    end
  end

  add("")
  add((" Loaded (%d)"):format(#state.clean), "PackFloatSection")
  for _, plugin in ipairs(state.clean) do
    add_plugin(plugin, false)
  end

  add("")
  add((" Inactive (%d)"):format(#state.not_loaded), "PackFloatSection")
  if #state.not_loaded == 0 then
    add("  no inactive plugins", "PackFloatMuted")
  else
    for _, plugin in ipairs(state.not_loaded) do
      add_plugin(plugin, false)
    end
  end

  state.line_to_name = line_to_name
  state.name_to_line = name_to_line

  return lines, hls
end

render = function()
  if not valid_buffer() then return end
  local lines, hls = build_content()
  set_lines(lines, hls)
end

local function load_commits(plugin, check_id)
  local name = plugin.spec.name
  state.commits[name] = nil
  vim.system({
    "git",
    "-C",
    plugin.path,
    "log",
    "--oneline",
    "--no-decorate",
    plugin.rev .. ".." .. plugin.rev_to,
  }, { text = true }, function(result)
    vim.schedule(function()
      if state.check_id ~= check_id or not valid_buffer() then return end
      state.commits[name] = result.code == 0 and split_lines(result.stdout)
        or {}
      render()
    end)
  end)
end

local function finish_refresh(check_id, failures)
  if state.check_id ~= check_id or not valid_buffer() then return end

  stop_check_animation()
  state.checking = false
  state.status = failures > 0 and ("ready, %d fetch failed"):format(failures)
    or "ready"
  render()
end

local function refresh_local(status)
  vim.schedule(function()
    local ok, plugins_or_err = pcall(vim.pack.get, nil, { offline = true })
    if not ok then
      state.status = tostring(plugins_or_err)
      render()
      return
    end

    state.commits = {}
    set_plugins(plugins_or_err)
    state.status = status or "ready"
    render()

    for _, plugin in ipairs(state.pending) do
      load_commits(plugin, state.check_id)
    end
  end)
end

local function refresh_fetch_async()
  if state.checking then return end

  state.checking = true
  state.status = "fetching remotes"
  state.check_id = state.check_id + 1
  local check_id = state.check_id
  local total = #state.plugins
  local remaining = total
  local failures = 0
  state.commits = {}
  start_check_animation()
  render()

  if total == 0 then
    finish_refresh(check_id, failures)
    return
  end

  for _, plugin in ipairs(state.plugins) do
    local name = plugin.spec.name
    vim.system({
      "git",
      "-C",
      plugin.path,
      "fetch",
      "--quiet",
      "--tags",
      "--force",
      "--recurse-submodules=yes",
      "origin",
    }, {}, function(fetch_result)
      vim.schedule(function()
        if state.check_id ~= check_id or not valid_buffer() then return end

        if fetch_result.code ~= 0 then
          failures = failures + 1
        else
          local ok, plugin_data = pcall(
            vim.pack.get,
            { name },
            { offline = true }
          )
          if ok and plugin_data[1] then
            replace_plugin(plugin_data[1])
            if is_pending(plugin_data[1]) then
              load_commits(plugin_data[1], check_id)
            end
          else
            failures = failures + 1
          end
        end

        remaining = remaining - 1
        state.status = ("fetching remotes %d/%d"):format(
          total - remaining,
          total
        )
        render()

        if remaining == 0 then finish_refresh(check_id, failures) end
      end)
    end)
  end
end

local function refresh(fetch)
  if fetch then
    refresh_fetch_async()
  else
    refresh_local()
  end
end

local function close()
  if state.autocmd then
    pcall(api.nvim_del_autocmd, state.autocmd)
    state.autocmd = nil
  end
  if valid_window() then api.nvim_win_close(state.winid, true) end
  state.winid = nil
  state.bufnr = nil
  state.check_id = state.check_id + 1
  state.checking = false
  stop_check_animation()
end

local function update_plugins(names)
  if #names == 0 then
    vim.notify("vim.pack: no pending updates", vim.log.levels.INFO)
    return
  end

  state.status = "updating " .. table.concat(names, ", ")
  render()

  vim.schedule(function()
    local ok, err =
      pcall(vim.pack.update, names, { force = true, offline = true })
    if not ok then
      vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
      state.status = "update failed"
      render()
      return
    end
    refresh(false)
  end)
end

local function update_current()
  local name = plugin_at_cursor()
  if not name then return end
  for _, plugin in ipairs(state.pending) do
    if plugin.spec.name == name then
      update_plugins({ name })
      return
    end
  end
  vim.notify(
    ("vim.pack: %s has no pending update"):format(name),
    vim.log.levels.INFO
  )
end

local function update_all()
  local names = vim
    .iter(state.pending)
    :map(function(plugin) return plugin.spec.name end)
    :totable()
  update_plugins(names)
end

local function uninstall_current()
  local name = plugin_at_cursor()
  if not name then return end

  if not vim.pack.del then
    vim.notify("vim.pack.del is unavailable", vim.log.levels.ERROR)
    return
  end

  local prompt = (
    "Uninstall %s from disk?\n"
    .. "Remove its vim.pack.add() spec too, or it may reinstall on restart."
  ):format(name)
  local choice = vim.fn.confirm(prompt, "&Uninstall\n&Cancel", 2)
  if choice ~= 1 then return end

  state.check_id = state.check_id + 1
  state.checking = false
  stop_check_animation()
  state.status = "uninstalling " .. name
  render()

  vim.schedule(function()
    local ok, err = pcall(vim.pack.del, { name }, { force = true })
    if not ok then
      vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
      state.status = "uninstall failed"
      render()
      return
    end

    state.commits[name] = nil
    state.expanded[name] = nil
    vim.notify(("vim.pack: uninstalled %s"):format(name), vim.log.levels.INFO)
    refresh_local(("removed %s"):format(name))
  end)
end

local function jump(direction)
  if not valid_window() then return end
  local row = api.nvim_win_get_cursor(state.winid)[1]
  local rows = vim.tbl_keys(state.line_to_name)
  table.sort(rows)
  if direction > 0 then
    for _, next_row in ipairs(rows) do
      if next_row > row then
        api.nvim_win_set_cursor(state.winid, { next_row, 0 })
        return
      end
    end
    if rows[1] then api.nvim_win_set_cursor(state.winid, { rows[1], 0 }) end
  else
    for i = #rows, 1, -1 do
      if rows[i] < row then
        api.nvim_win_set_cursor(state.winid, { rows[i], 0 })
        return
      end
    end
    if rows[#rows] then
      api.nvim_win_set_cursor(state.winid, { rows[#rows], 0 })
    end
  end
end

local function toggle_details()
  local name = plugin_at_cursor()
  if not name then return end
  state.expanded[name] = not state.expanded[name]
  render()
  if valid_window() and state.name_to_line[name] then
    api.nvim_win_set_cursor(state.winid, { state.name_to_line[name], 0 })
  end
end

local function map(lhs, rhs, desc)
  vim.keymap.set(
    "n",
    lhs,
    rhs,
    { buffer = state.bufnr, silent = true, nowait = true, desc = desc }
  )
end

local function setup_keymaps()
  map("q", close, "Close")
  map("<Esc>", close, "Close")
  map("r", function() refresh(true) end, "Refresh updates")
  map("u", update_current, "Update plugin")
  map("U", update_all, "Update all pending")
  map("x", uninstall_current, "Uninstall plugin")
  map("<CR>", toggle_details, "Toggle details")
  map("]]", function() jump(1) end, "Next plugin")
  map("[[", function() jump(-1) end, "Previous plugin")
end

function M.open(opts)
  opts = opts or {}

  if valid_window() then
    api.nvim_set_current_win(state.winid)
    return
  end

  setup_highlights()

  state.bufnr = api.nvim_create_buf(false, true)
  vim.bo[state.bufnr].buftype = "nofile"
  vim.bo[state.bufnr].bufhidden = "wipe"
  vim.bo[state.bufnr].swapfile = false
  vim.bo[state.bufnr].filetype = "pack-float"

  local columns = vim.o.columns
  local screen_lines = vim.o.lines
  local width = math.min(100, math.max(64, math.floor(columns * 0.82)))
  local height = math.min(32, math.max(18, math.floor(screen_lines * 0.72)))

  state.winid = api.nvim_open_win(state.bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((screen_lines - height) / 2),
    col = math.floor((columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " vim.pack ",
    title_pos = "center",
  })

  vim.wo[state.winid].cursorline = true
  vim.wo[state.winid].wrap = true
  vim.wo[state.winid].linebreak = true
  vim.wo[state.winid].breakindent = true

  reset_data()
  load_fast_plugin_list()
  setup_keymaps()
  render()

  local captured_win = state.winid
  state.autocmd = api.nvim_create_autocmd("WinClosed", {
    once = true,
    callback = function(ev)
      if vim._tointeger(ev.match) == captured_win then
        state.autocmd = nil
        state.winid = nil
        state.bufnr = nil
        state.check_id = state.check_id + 1
        state.checking = false
        stop_check_animation()
      end
    end,
  })

  refresh(opts.fetch ~= false)
end

api.nvim_create_user_command(
  "PackFloat",
  function(command) M.open({ fetch = not command.bang }) end,
  {
    bang = true,
    desc = "Open lazy-style vim.pack UI",
  }
)

return M
