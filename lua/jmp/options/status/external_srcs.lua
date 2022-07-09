local M = {}
local gap = "  "

--- Create a string of diagnostic information
-- @tparam  lsp_signs: dict of signs used for diagnostics
-- @tparam  hl_dict: dict of highlights for statusline
-- @treturn success str: string indicating no diagnostics available
-- @treturn diagnostic str: string indicating diagnostics available
M.get_diag_str = function(lsp_signs, hl_dict)
  if #vim.diagnostic.get(0) < 1 then
    local success_sym = ""
    return table.concat({ hl_dict["Success"].hl_str, success_sym, "%* " })
  end

  local count = nil
  local diag_tbl = {}

  for _, type in pairs({ "Error", "Warn", "Hint", "Info" }) do
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

M.get_git_branch = function(success_hl, branch_icon)
  local branch = vim.b.gitsigns_head

  if branch then
    branch = table.concat({ success_hl, branch_icon, "%* ", branch })
  else
    branch = "[No Repo]"
  end

  return gap .. branch
end

--- Get wordcount for current buffer
-- @treturn string containing word count
M.get_wordcount_str = function()
  local wc = vim.api.nvim_eval("wordcount()")["words"]

  return string.format("words: %d%s", wc, gap)
end

return M
