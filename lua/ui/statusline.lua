local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local get_opt = api.nvim_get_option_value

local icons = tools.ui.icons
local mini_icons = require("mini.icons")

local HL = {
  branch = { "DiagnosticOk", icons.branch },
  file = { "NonText", icons.node },
  fileinfo = { "DiagnosticInfo", icons.document },
  nomodifiable = { "DiagnosticWarn", icons.bullet },
  modified = { "DiagnosticError", icons.bullet },
  readonly = { "DiagnosticWarn", icons.lock },
  error = { "DiagnosticError", icons.error },
  warn = { "DiagnosticWarn", icons.warning },
  visual = { "DiagnosticInfo", "‹› " },
}

local ICON = {}
for k, v in pairs(HL) do
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

-- path and git info -----------------------------------------
local function path_widget(root, fname)
  local file_name = fn.fnamemodify(fname, ":t")

  local path, icon, hl
  icon, hl = mini_icons.get("file", file_name)

  if fname == "" then file_name = "[No Name]" end
  path = tools.hl_str(hl, icon) .. file_name

  if bo.buftype == "help" then return ICON.file .. path end

  local dir_path = fn.fnamemodify(fname, ":h") .. "/"
  if dir_path == "./" then dir_path = "" end

  local remote = tools.get_git_remote_name(root)
  local branch = tools.get_git_branch(root)
  local repo_info = ""
  if remote and branch then
    dir_path = dir_path:gsub("^" .. esc_str(root) .. "/", "")
    repo_info = string.format("%s %s @ %s ", ICON.branch, remote, branch)
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
  local err, warn = diag_count[1] or 0, diag_count[2] or 0
  return string.format("%s %-3d  %s %-3d  ", ICON.error, err, ICON.warn, warn)
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
  local fname = api.nvim_buf_get_name(0)
  local root = (bo.buftype == "" and tools.get_path_root(fname)) or nil
  if bo.buftype ~= "" and bo.buftype ~= "help" then fname = bo.ft end

  local buf = api.nvim_win_get_buf(vim.g.statusline_winid)

  local parts = {
    pad = PAD,
    path = path_widget(root, fname),
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
