local utils = require("ui.utils")
local get_opt = vim.api.nvim_get_option_value

local M = {}

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
  buf_info = nil,
  diag = nil,
  git_info = nil,
  modifiable = nil,
  modified = nil,
  pad = " ",
  path = nil,
  ro = nil,
  scrollbar = nil,
  sep = "%=",
  trunc = "%<",
  venv = nil
}

local stl_order = {
  "pad",
  "path",
  "mod",
  "ro",
  "sep",
  "venv",
  "sep",
  "diag",
  "fileinfo",
  "pad",
  "scrollbar",
  "pad"
}

local icons = tools.ui.icons

local ui_icons = {
  ["branch"] = { "DiagnosticOk", icons["branch"] },
  ["file"] = { "NonText", icons["file"] },
  ["fileinfo"] = { "DiagnosticInfo", icons["hamburger"] },
  ["nomodifiable"] = { "DiagnosticWarn", icons["bullet"] },
  ["modified"] = { "DiagnosticError", icons["bullet"] },
  ["readonly"] = { "DiagnosticWarn", icons["lock"] },
  ["searchcount"] = { "DiagnosticInfo", icons["location"] },
  ["error"] = { "DiagnosticError", icons["ballot_x"] },
  ["warn"] = { "DiagnosticWarn", icons["up_tri"] },
}

--------------------------------------------------
-- Utilities
--------------------------------------------------
local function hl_str(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

local function hl_icons(icon_list)
  local hl_syms = {}

  for name, list in pairs(icon_list) do
    hl_syms[name] = hl_str(list[1], list[2])
  end

  return hl_syms
end

-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function ordered_tbl_concat(order_tbl, stl_part_tbl)
  local str_table = {}
  local part = nil

  for _, val in ipairs(order_tbl) do
    part = stl_part_tbl[val]
    if part then table.insert(str_table, part) end
  end

  return table.concat(str_table, " ")
end


--------------------------------------------------
-- String Generation
--------------------------------------------------
local hl_ui_icons = hl_icons(ui_icons)

local function escape_str(str)
  local output = str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
  return output
end

-- PATH WIDGET
--- Create a string containing info for the current git branch
--- @return string: branch info
local function get_path_info(root, fname, icon_tbl)
  local file_name = vim.fn.fnamemodify(fname, ":t")

  local file_icon, icon_hl = require("mini.icons").get('file', file_name)
  file_icon = file_name ~= "" and hl_str(icon_hl, file_icon) or ""

  local file_icon_name = table.concat({ file_icon, file_name })

  if vim.bo.buftype == "help" then
    return table.concat({ icon_tbl["file"], file_icon_name })
  end

  local remote = tools.get_git_remote_name(root)
  local branch = tools.get_git_branch(root)
  local dir_path = vim.fn.fnamemodify(fname, ":h") .. "/"
  local win_width = vim.api.nvim_win_get_width(0)
  local dir_threshold_width = 15
  local repo_threshold_width = 10

  local repo_info = ""
  if remote and branch then
    dir_path = string.gsub(dir_path, "^" .. escape_str(root) .. "/", "")

    repo_info = table.concat({
      icon_tbl["branch"],
      ' ',
      remote,
      ':',
      branch,
      ' ',
    })
  end

  dir_path = win_width >= dir_threshold_width + #repo_info + #dir_path + #file_icon_name and dir_path or ""

  repo_info = win_width >= repo_threshold_width + #repo_info + #file_icon_name and repo_info or ""

  return table.concat({
    repo_info,
    icon_tbl["file"],
    dir_path,
    file_icon_name
  })
end


-- DIAGNOSTIC WIDGET
--- Create a string of diagnostic information
--- @return string available diagnostics
local function get_diag_str()
  if not tools.diagnostics_available() then
    return ""
  end

  local diag_tbl = {}
  local total = vim.diagnostic.count()
  local err_total = total[1] or 0
  local warn_total = total[2] or 0

  vim.list_extend(diag_tbl, { hl_ui_icons["error"], ' ', utils.pad_str(tostring(err_total), 3, "left"), ' ' })
  vim.list_extend(diag_tbl, { hl_ui_icons["warn"], ' ', utils.pad_str(tostring(warn_total), 3, "left"), ' ' })

  return table.concat(diag_tbl)
end


-- FILEINFO WIDGET
local function get_filesize()
  local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
  local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))

  -- Handle invalid file size
  if fsize < 0 then return "0b" end

  local i = math.floor(math.log(fsize) / math.log(1024))
  -- Ensure index is within suffix range
  i = math.min(i, #suffix - 1)

  return string.format("%.1f%s", fsize / 1024 ^ i, suffix[i + 1])
end

local function get_vlinecount_str()
  local raw_count = vim.fn.line('.') - vim.fn.line('v')
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

  return tools.group_number(math.abs(raw_count), ',')
end

local function is_user_typing_search()
  local cmd_type = vim.fn.getcmdtype()
  return cmd_type == "/" or cmd_type == "?"
end

--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_widget(icon_tbl)
  if vim.v.hlsearch == 1 and not is_user_typing_search() then
    local sinfo = vim.fn.searchcount()
    local search_stat = sinfo.incomplete > 0 and 'press enter'
        or sinfo.total > 0 and ('%s/%s'):format(sinfo.current, sinfo.total)
        or nil

    if search_stat ~= nil then
      return table.concat({ icon_tbl.searchcount, ' ', search_stat, ' ' })
    end
  end

  local ft = get_opt("filetype", {})
  local lines = tools.group_number(vim.api.nvim_buf_line_count(0), ',')

  -- For source code: return icon and line count
  if not tools.nonprog_modes[ft] then
    return table.concat({ icon_tbl.fileinfo, " ", lines, " lines" })
  end

  local wc_table = vim.fn.wordcount()
  if not wc_table.visual_words or not wc_table.visual_chars then
    -- Normal mode word count and file info
    return table.concat({
      icon_tbl.fileinfo,
      ' ',
      get_filesize(),
      '  ',
      lines,
      " lines  ",
      tools.group_number(wc_table.words, ','),
      " words "
    })
  else
    -- Visual selection mode: line count, word count, and char count
    return table.concat({
      hl_str("DiagnosticInfo", '‹›'),
      ' ',
      get_vlinecount_str(),
      " lines  ",
      tools.group_number(wc_table.visual_words, ','),
      " words  ",
      tools.group_number(wc_table.visual_chars, ','),
      " chars"
    })
  end
end


--- Get the name of the current venv in Python
--- @return string|nil name of venv or nil
--- From JDHao; see https://www.reddit.com/r/neovim/comments/16ya0fr/show_the_current_python_virtual_env_on_statusline/
local get_py_venv = function()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("'.venv': %s  ", venv_name)
  end

  local conda_env = os.getenv('CONDA_DEFAULT_ENV')
  if conda_env then
    return string.format("conda: %s  ", conda_env)
  end

  return nil
end

local function get_scrollbar()
  local sbar_chars = {
    '▔',
    '🮂',
    '🬂',
    '🮃',
    '▀',
    '🮑',
    '🮒',
    '▄',
    '▃',
    '🬭',
    '▂',
    '▁',
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 2)

  return hl_str("Substitute", sbar)
end


--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local root = nil
  if vim.bo.buftype == "terminal" or
      vim.bo.buftype == "nofile" or
      vim.bo.buftype == "prompt" then
    fname = vim.bo.ft
  else
    root = tools.get_path_root(fname)
  end

  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

  stl_parts["path"] = get_path_info(root, fname, hl_ui_icons)
  stl_parts["ro"] = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or ""

  if not get_opt("modifiable", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["nomodifiable"]
  elseif get_opt("modified", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["modified"]
  else
    stl_parts["mod"] = " "
  end

  -- middle
  -- filetype-specific info
  if vim.bo.filetype == "python" then
    stl_parts["venv"] = get_py_venv()
  end

  -- right
  stl_parts["diag"] = get_diag_str()
  stl_parts["fileinfo"] = get_fileinfo_widget(hl_ui_icons)
  stl_parts["scrollbar"] = get_scrollbar()

  -- turn all of these pieces into one string
  return ordered_tbl_concat(stl_order, stl_parts)
end


vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
