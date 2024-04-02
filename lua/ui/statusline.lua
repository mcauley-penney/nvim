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
  sep = "%=",
  trunc = "%<",
  venv = nil
}

local stl_order = {
  "pad",
  --  "mode",
  "git_info",
  "path",
  "ro",
  "mod",
  "sep",
  "venv",
  "sep",
  "diag",
  "fileinfo",
  "pad",
}

local get_hl = tools.get_hl_hex
local icons = tools.ui.icons

local palette = {
  Error = get_hl({ name = "DiagnosticError" })["fg"],
  Hint = get_hl({ name = "DiagnosticHint" })["fg"],
  Info = get_hl({ name = "DiagnosticInfo" })["fg"],
  Ok = get_hl({ name = "DiagnosticOk" })["fg"],
  Warn = get_hl({ name = "DiagnosticWarn" })["fg"],
  Muted = get_hl({ name = "NonText" })["fg"],
  bg = get_hl({ name = "StatusLine" })["bg"],
}

local ui_icons = {
  ["branch"] = { "Ok", icons["branch"] },
  ["file"] = { "Muted", icons["file"] },
  ["fileinfo"] = { "Info", icons["hamburger"] },
  ["nomodifiable"] = { "Warn", icons["bullet"] },
  ["modified"] = { "Error", icons["bullet"] },
  ["readonly"] = { "Warn", icons["lock"] },
}

local signs = tools.ui.lsp_signs


--------------------------------------------------
-- Highlighting
--------------------------------------------------
local function make_stl_hl_str(hl_grp_str, text)
  return table.concat({ hl_grp_str, text, "%*" })
end

local function make_ui_hl_grps(hi_palette)
  local ui_bg = hi_palette["bg"]
  local hi_grps_tbl = {}

  local grp_name = nil
  for name, color in pairs(hi_palette) do
    grp_name = "UI" .. name
    vim.api.nvim_set_hl(0, grp_name, { fg = color, bg = ui_bg })
    grp_name = table.concat({ "%#", grp_name, "#" }, "")
    hi_grps_tbl[name] = grp_name
  end

  return hi_grps_tbl
end


local function hl_icons(icon_list, hl_grps)
  local hled_icons = {}

  for name, list in pairs(icon_list) do
    hled_icons[name] = make_stl_hl_str(hl_grps[list[1]], list[2])
  end

  return hled_icons
end


local function hl_lsp_icons(lsp_icons, hl_grps)
  local hl_syms = {}
  local sign_hl

  for diag_type, sym in pairs(lsp_icons) do
    sign_hl = table.concat({ "DiagnosticSign", diag_type })
    vim.fn.sign_define(sign_hl, { text = sym, texthl = sign_hl })
    hl_syms[diag_type] = make_stl_hl_str(hl_grps[diag_type], sym)
  end

  return hl_syms
end


--------------------------------------------------
-- Utilities
--------------------------------------------------

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
-- Rendering
--------------------------------------------------

local hl_grp_tbl = make_ui_hl_grps(palette)
local hl_ui_icons = hl_icons(ui_icons, hl_grp_tbl)
local lsp_signs = hl_lsp_icons(signs, hl_grp_tbl)


--- Create a string containing info for the current git branch
--- @return string: branch info
local function get_git_info(root, icon_tbl)
  local remote = tools.get_git_remote_name(root)
  local branch = tools.get_git_branch(root)

  if remote and branch then
    return table.concat({ icon_tbl["branch"], ' ', remote, ':', branch })
  end

  return ''
end


--- Get filepath
--- see https://github.com/NvChad/ui/pull/185/files
local function get_filepath(icon_tbl)
  local filename = vim.fn.expand("%:p")

  return table.concat({ icon_tbl["file"], ' ', stl_parts["trunc"], filename })
end


--- Create a string of diagnostic information
--- @param lsp_syms table dict of signs used for diagnostics
--- @return string available diagnostics
local function get_diag_str(lsp_syms)
  if not tools.diagnostics_available() then
    return ""
  end

  local count = nil
  local count_str = nil
  local diag_tbl = {}

  for _, type in pairs({ "Error", "Warn" }) do
    count = #vim.diagnostic.get(0, { severity = string.upper(type) })
    count_str = utils.pad_str(tostring(count), 3, "left")
    vim.list_extend(diag_tbl, { lsp_syms[type], ' ', count_str, ' ' })
  end

  return table.concat(diag_tbl)
end


--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_str(icon_tbl)
  local function get_filesize()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize

    if fsize < 1024 then
      return fsize .. suffix[1]
    end

    local i = math.floor((math.log(fsize) / math.log(1024)))

    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
  end

  local function get_vlinecount_str()
    local raw_count = vim.fn.line('.') - vim.fn.line('v')
    raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

    return tostring(math.abs(raw_count))
  end

  local count_parts_order = {
    "icon",
    "size",
    "lc",
    "wc",
    "cc",
  }

  local count_parts = {
    icon = icon_tbl.fileinfo,
    size = nil,
    lc = "%L lines",
    wc = nil,
    cc = nil
  }

  local ft = get_opt("filetype", {})

  if not tools.nonprog_mode[ft] then
    return ordered_tbl_concat(count_parts_order, count_parts)
  end

  count_parts["size"] = get_filesize() .. ' '

  local wc_table = vim.fn.wordcount()

  if wc_table.visual_words and wc_table.visual_chars then
    count_parts["lc"] = get_vlinecount_str() .. " lines "
    count_parts["wc"] = wc_table.visual_words .. " words "
    count_parts["cc"] = wc_table.visual_chars .. " chars"

    return ordered_tbl_concat(count_parts_order, count_parts)
  end

  count_parts["wc"] = ' ' .. wc_table.words .. " words "

  return ordered_tbl_concat(count_parts_order, count_parts)
end


--- Get the name of the current venv in Python
--- @return string|nil name of venv or nil
--- From JDHao; see https://www.reddit.com/r/neovim/comments/16ya0fr/show_the_current_python_virtual_env_on_statusline/
local get_py_venv = function()
  -- only show virtual env for Python
  if vim.bo.filetype ~= "python" then
    return nil
  end

  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("venv: %s", venv_name)
  end

  local conda_env = os.getenv('CONDA_DEFAULT_ENV')
  if conda_env then
    return string.format("conda: %s", conda_env)
  end

  return nil
end

--  local function get_mode()
--    -- Note that: \19 = ^S and \22 = ^V.
--    local mode_to_str = {
--      ['n'] = 'NORMAL',
--      ['no'] = 'OP-PENDING',
--      ['nov'] = 'OP-PENDING',
--      ['noV'] = 'OP-PENDING',
--      ['no\22'] = 'OP-PENDING',
--      ['niI'] = 'NORMAL',
--      ['niR'] = 'NORMAL',
--      ['niV'] = 'NORMAL',
--      ['nt'] = 'NORMAL',
--      ['ntT'] = 'NORMAL',
--      ['v'] = 'CHAR VISUAL',
--      ['vs'] = 'VISUAL',
--      ['V'] = 'LINE VISUAL',
--      ['Vs'] = 'VISUAL',
--      ['\22'] = 'BLOCK VISUAL',
--      ['\22s'] = 'VISUAL',
--      ['s'] = 'SELECT',
--      ['S'] = 'SELECT',
--      ['\19'] = 'SELECT',
--      ['i'] = 'INSERT',
--      ['ic'] = 'INSERT',
--      ['ix'] = 'INSERT',
--      ['R'] = 'REPLACE',
--      ['Rc'] = 'REPLACE',
--      ['Rx'] = 'REPLACE',
--      ['Rv'] = 'VIRT REPLACE',
--      ['Rvc'] = 'VIRT REPLACE',
--      ['Rvx'] = 'VIRT REPLACE',
--      ['c'] = 'COMMAND',
--      ['cv'] = 'VIM EX',
--      ['ce'] = 'EX',
--      ['r'] = 'PROMPT',
--      ['rm'] = 'MORE',
--      ['r?'] = 'CONFIRM',
--      ['!'] = 'SHELL',
--      ['t'] = 'TERMINAL',
--    }
--
--    return mode_to_str[vim.api.nvim_get_mode().mode] or 'UNKNOWN'
--  end


--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
  if vim.bo.buftype == "terminal" or
      vim.bo.buftype == "nofile" or
      vim.bo.buftype == "prompt" then
    return "%#StatusLineNC#"
  end

  local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

  --  stl_parts["mode"] = get_mode()
  stl_parts["git_info"] = get_git_info(root, hl_ui_icons)
  stl_parts["path"] = get_filepath(hl_ui_icons)
  stl_parts["ro"] = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or ""

  if not get_opt("modifiable", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["nomodifiable"]
  elseif get_opt("modified", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["modified"]
  else
    stl_parts["mod"] = ""
  end

  -- middle
  -- filetype-specific info
  stl_parts["venv"] = get_py_venv()

  --  -- right
  stl_parts["diag"] = get_diag_str(lsp_signs)
  stl_parts["fileinfo"] = get_fileinfo_str(hl_ui_icons)

  -- turn all of these pieces into one string
  return ordered_tbl_concat(stl_order, stl_parts)
end


vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
