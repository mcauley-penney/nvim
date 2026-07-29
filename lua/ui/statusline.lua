local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local get_opt = api.nvim_get_option_value

local icons = tools.ui.icons
local real_icons = require("real-icons")

local ICON = {
  branch = { "DiagnosticOk", icons.branch },
  file = { "NonText", icons.node },
  fileinfo = { "Function", icons.document },
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

  local win_w = api.nvim_win_get_width(0)
  local need = #repo_info + #dir_path + #path
  if win_w < need + 5 then dir_path = "" end
  if win_w < need - #dir_path then repo_info = "" end

  return repo_info .. ICON.file .. " " .. dir_path .. path .. " "
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
    tools.hl_str("Normal", err),
    ICON.warn,
    tools.hl_str("Normal", warn)
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
    str = string.format("[conda: %s]  ", env)
    return tools.hl_str("Comment", str)
  end
  return tools.hl_str("Comment", "[no venv]")
end

-- scrollbar ---------------------------------------------
local function scrollbar_widget()
  local cur = api.nvim_win_get_cursor(0)[1]
  local total = api.nvim_buf_line_count(0)
  local idx = math.floor((cur - 1) / total * #SBAR) + 1
  return tools.hl_str("Substitute", SBAR[idx]:rep(2))
end

-- render ---------------------------------------------
function M.render()
  local curbuf_path = api.nvim_buf_get_name(0)
  local root = (bo.buftype == "" and tools.get_path_root(curbuf_path)) or nil
  if bo.buftype ~= "" and bo.buftype ~= "help" then curbuf_path = bo.ft end

  local buf = api.nvim_win_get_buf(vim.g.statusline_winid)

  local parts = {
    pad = PAD,
    project = project_widget(root, curbuf_path),
    path = path_widget(root, curbuf_path),
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
