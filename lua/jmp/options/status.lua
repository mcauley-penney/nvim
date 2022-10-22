local styles = require("jmp.style")
local hl_dict = styles.palette_grps
local icons = styles.icons
local gap = "  "

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
  buf_info = nil,
  diag = nil,
  git_branch = nil,
  loc = "%l/%-4L ",
  mod = nil,
  path = " %<%F",
  ro = nil,
  sep = "%=",
}

local stl_order = {
  "git_branch",
  "path",
  "ro",
  "mod",
  "sep",
  "diag",
  "wordcount",
  "loc",
}

local function get_modified(buf, hl, icon)
  if vim.bo[buf].modified then
    return table.concat({ hl, icon, "%* " })
  end
end

local function is_ro(buf, hl, icon)
  if vim.bo[buf].readonly then
    return table.concat({ hl, icon, "%* " })
  end
end

--- Create a string of diagnostic information
-- @tparam lsp_signs: dict of signs used for diagnostics
-- @tparam hl_dict: dict of highlights for statusline
-- @treturn success str: string indicating no diagnostics available
-- @treturn diagnostic str: string indicating diagnostics available
local function get_diag_str(lsp_signs, hl_dict)
  if #vim.diagnostic.get(0) < 1 then
    local success_sym = ""
    return table.concat({ hl_dict["Success"].hl_str, success_sym, "%* " })
  end

  local count = nil
  local diag_tbl = {}

  for _, type in pairs({ "Error", "Warn", "Info", "Hint" }) do
    count = #vim.diagnostic.get(0, { severity = string.upper(type) })

    vim.list_extend(diag_tbl, {
      hl_dict[type].hl_str,
      lsp_signs[type],
      "%*:",
      count,
      gap,
    })
  end

  return table.concat(diag_tbl)
end

--- Create a string containing info for the current git branch
-- @treturn string: branch name or "[No Repo]"
-- alternative, for if we ever stopped using gitsigns:
-- https://www.reddit.com/r/neovim/comments/uz3ofs/heres_a_function_to_grab_the_name_of_the_current/

local function get_git_branch(hl_tbl, branch_icon)
  local branch = vim.b.gitsigns_head

  if branch then
    branch = table.concat({ hl_tbl["Success"].hl_str, branch_icon, "%* ", branch })
  else
    branch = table.concat({ hl_tbl["Failure"].hl_str, "[No Repo]", "%* " })
  end

  return gap .. branch
end

--- Get wordcount for current buffer
-- @treturn string containing word count
local function get_wordcount_str()
  local wc = vim.api.nvim_eval("wordcount()")["words"]

  return string.format("\\w: %d%s", wc, gap)
end

-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function concat_status(order_tbl, stl_part_tbl)
  local str_table = {}

  for _, val in ipairs(order_tbl) do
    table.insert(str_table, stl_part_tbl[val])
  end

  return table.concat(str_table, " ")
end

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
--
-- NOTES:
--  • tracking window status
--      1. Should avoid autocommands to track current statusline, see
--      https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
--
--      2. Can track via global vars, see
--      https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
--
_G.get_statusline = function()
  if vim.bo.buftype == "terminal" then
    return "%#StatusLineNC#"
  end

  local curbuf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

  stl_parts["mod"] = get_modified(curbuf, hl_dict["Error"].hl_str, icons["mod"])
  stl_parts["ro"] = is_ro(curbuf, hl_dict["Warn"].hl_str, icons["ro"])

  stl_parts["git_branch"] = get_git_branch(hl_dict, icons["branch"])

  if #vim.lsp.buf_get_clients() > 0 then
    stl_parts["diag"] = get_diag_str(styles.signs, hl_dict)
  end

  if vim.api.nvim_buf_get_option(0, "filetype") == "text" then
    stl_parts["wordcount"] = get_wordcount_str()
  end

  -- concatenate desired status components into str
  return concat_status(stl_order, stl_parts)
end
