local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local get_opt = api.nvim_get_option_value
local icons = tools.ui.icons
local real_icons = require("real-icons")
local git_popup_win

local ICON = {
  branch = { "DiagnosticOk", icons.branch },
  fileinfo = { "Keyword", icons.document },
  nomodifiable = { "DiagnosticWarn", icons.bullet },
  modified = { "DiagnosticError", icons.bullet },
  readonly = { "DiagnosticWarn", icons.lock },
  error = { "DiagnosticError", icons.error },
  warn = { "DiagnosticWarn", icons.warning },
  visual = { "DiagnosticInfo", "‹› " },
}

for k, v in pairs(ICON) do
  ICON[k] = tools.hl_str(v[1], v[2])
end

local ORDER = {
  "pad",
  "git",
  "project",
  "path",
  "venv",
  "mod",
  "ro",
  "sep",
  "diag",
  "fileinfo",
  "pad",
  "scrollbar",
  "pad",
}

local PAD = " "
local SEP = "%="
local SBAR =
  { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }

-- utilities -----------------------------------------
local function concat(parts)
  local out, i = {}, 1
  for _, k in ipairs(ORDER) do
    local v = parts[k]
    if v and v ~= "" then
      out[i] = v
      i = i + 1
    end
  end
  return table.concat(out, " ")
end

local function esc_str(str)
  return str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
end

local function file_icon(fname)
  local icon_segment = real_icons.segment("file", fname, {
    filetype = bo.filetype,
    is_dir = false,
  })

  return table.concat({
    tools.hl_str(icon_segment.hl, icon_segment.text),
    " ",
  })
end

local function folder_icon(root)
  local icon_segment = real_icons.segment("directory", root, {
    is_dir = true,
  })

  return table.concat({
    tools.hl_str(icon_segment.hl, icon_segment.text),
    " ",
  })
end

-- path and git info -----------------------------------------
local function git_popup_icon()
  local open = git_popup_win and api.nvim_win_is_valid(git_popup_win)

  return open and "󰘕" or "󰘖"
end

local function git_divergence(state)
  local parts = {}
  local ahead = state.ahead and state.ahead or 0
  local behind = state.behind and state.behind or 0

  parts[#parts + 1] = tools.hl_str("String", "↑") .. ahead
  parts[#parts + 1] = tools.hl_str("Number", "↓") .. behind

  return table.concat(parts, " ")
end

local function git_widget(root)
  if not root then return "" end

  local state = tools.get_git_state(root)
  if not state then return ICON.branch .. "[NO REPO]" end

  local status = state.head .. " "

  if state.oid == "(initial)" then
    status = status .. "[UNBORN]"
  elseif state.head == "(detached)" then
    status = string.format("%s [DETACHED HEAD]", state.oid:sub(1, 7))
  else
    local divergence = git_divergence(state)
    status = status .. divergence
  end

  return table.concat({
    "%@v:lua.StatuslineGitClick@",
    ICON.branch,
    status,
    "  ",
    tools.hl_str("Comment", git_popup_icon()),
    "%T",
    "  ",
  })
end

local function project_widget(root, fname)
  local icon
  local project_path

  if not root then
    icon = folder_icon(fname)
    project_path = vim.fs.dirname(fname)
  else
    icon = folder_icon(root)
    project_path = vim.fs.basename(root)
  end

  return table.concat({
    " ",
    icon,
    project_path,
    " ›",
  })
end

local function path_widget(root, fname)
  local file_name = fn.fnamemodify(fname, ":t")

  if fname == "" then file_name = "[No Name]" end

  local pretty_fname = file_icon(fname) .. file_name
  if bo.buftype == "help" then return pretty_fname end

  if root then
    local dir_path = fn.fnamemodify(fname, ":h") .. "/"
    dir_path = dir_path:gsub("^" .. esc_str(root) .. "/", "")
    return dir_path .. " " .. pretty_fname
  end

  return pretty_fname
end

-- diagnostics ---------------------------------------------
local function diagnostics_widget()
  if not tools.diagnostics_available() then return "" end
  local diag_count = vim.diagnostic.count()
  local err, warn =
    string.format("%-3d", diag_count[1] or 0),
    string.format("%-3d", diag_count[2] or 0)

  return string.format(
    "%s %s  %s %s  ",
    ICON.error,
    tools.hl_str("StatusLine", err),
    ICON.warn,
    tools.hl_str("StatusLine", warn)
  )
end

-- file/selection info -------------------------------------
local function fileinfo_widget()
  local ft = get_opt("filetype", {})
  local lines = tools.group_number(api.nvim_buf_line_count(0), ",")
  local str = ICON.fileinfo .. " "

  if not tools.nonprog_modes[ft] then
    return str .. string.format("%3s lines", lines)
  end

  local wc = fn.wordcount()
  if not wc.visual_words then
    return str
      .. string.format(
        "%3s lines  %3s words",
        lines,
        tools.group_number(wc.words, ",")
      )
  end

  local vlines = math.abs(fn.line(".") - fn.line("v")) + 1
  return str
    .. string.format(
      "%3s lines %3s words  %3s chars",
      tools.group_number(vlines, ","),
      tools.group_number(wc.visual_words, ","),
      tools.group_number(wc.visual_chars, ",")
    )
end

-- python venv ---------------------------------------------
local function venv_widget()
  if bo.filetype ~= "python" then return "" end
  local env = vim.env.VIRTUAL_ENV

  local str
  if env and env ~= "" then
    str = string.format("[.venv: %s]  ", fn.fnamemodify(env, ":t"))
    return tools.hl_str("Comment", str)
  end
  env = vim.env.CONDA_DEFAULT_ENV
  if env and env ~= "" then
    str = string.format("[Conda: %s]  ", env)
    return tools.hl_str("Comment", str)
  end
  return tools.hl_str("Comment", "[NO VENV]")
end

-- scrollbar ---------------------------------------------
local function scrollbar_widget()
  local cur = api.nvim_win_get_cursor(0)[1]
  local total = api.nvim_buf_line_count(0)
  local idx = math.floor((cur - 1) / total * #SBAR) + 1
  return tools.hl_str("Substitute", SBAR[idx]:rep(2))
end

-- render ---------------------------------------------
function M.show_git_popup()
  if git_popup_win and api.nvim_win_is_valid(git_popup_win) then
    api.nvim_win_close(git_popup_win, true)
    git_popup_win = nil
    return
  end

  local mouse = vim.fn.getmousepos()
  local winid = mouse.winid

  if not api.nvim_win_is_valid(winid) then
    winid = api.nvim_get_current_win()
  end

  local root = api.nvim_win_call(winid, function()
    local fname = api.nvim_buf_get_name(0)
    return tools.get_path_root(fname)
  end)

  if not root then return end

  local state = tools.get_git_state(root)
  local remotes = tools.get_git_remotes(root)

  if not state then return end

  local tracking = state.upstream or "[NONE]"
  local remote_names

  if not remotes then
    remote_names = "[GIT ERROR]"
  elseif #remotes == 0 then
    remote_names = "[NONE]"
  else
    remote_names = table.concat(remotes, ", ")
  end

  local lines = {
    "TRACKING " .. tracking,
    "REMOTES  " .. remote_names,
  }

  local width =
    math.max(vim.fn.strdisplaywidth(lines[1]), vim.fn.strdisplaywidth(lines[2]))

  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  git_popup_win = api.nvim_open_win(buf, false, {
    relative = "mouse",
    anchor = "SW",
    row = 0,
    col = 0,
    width = width,
    height = #lines,
    style = "minimal",
    border = "solid",
    focusable = false,
  })
end

function _G.StatuslineGitClick(_, _, button, _)
  if button ~= "l" then return end
  require("ui.statusline").show_git_popup()
  vim.cmd.redrawstatus()
end

function M.render()
  local curbuf_path = api.nvim_buf_get_name(0)
  local root = (bo.buftype == "" and tools.get_path_root(curbuf_path)) or nil
  if bo.buftype ~= "" and bo.buftype ~= "help" then curbuf_path = bo.ft end

  local buf = api.nvim_win_get_buf(vim.g.statusline_winid)

  local parts = {
    pad = PAD,
    project = project_widget(root, curbuf_path),
    path = path_widget(root, curbuf_path),
    git = git_widget(root),
    venv = venv_widget(),
    mod = get_opt("modifiable", { buf = buf })
        and (get_opt("modified", { buf = buf }) and ICON.modified or " ")
      or ICON.nomodifiable,
    ro = get_opt("readonly", { buf = buf }) and ICON.readonly or "",
    sep = SEP,
    diag = diagnostics_widget(),
    fileinfo = fileinfo_widget(),
    scrollbar = scrollbar_widget(),
  }

  return concat(parts)
end

vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
