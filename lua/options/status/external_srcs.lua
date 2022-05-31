local M = {}

--- Create a string of diagnostic information
-- @tparam  lsp_signs: dict of signs used for diagnostics
-- @tparam  hl_dict: dict of highlights for statusline
-- @treturn success str: string indicating no diagnostics available
-- @treturn diagnostic str: string indicating diagnostics available
M.get_diag_str = function(lsp_signs, hl_dict)
    if #vim.diagnostic.get(0) < 1 then
        local success_sym = ""
        return table.concat({ hl_dict["Success"], success_sym, "%* " }, "")
    end

    local count = nil
    local diag_str = ""

    for _, type in pairs({ "Error", "Warn", "Hint", "Info" }) do
        count = #vim.diagnostic.get(0, { severity = string.upper(type) })

        diag_str = diag_str
            .. table.concat(
                { hl_dict[type], lsp_signs[type].sym, "%*:", count, "  " },
                ""
            )
    end

    return diag_str
end

--- Create a string containing the name of the current branch
-- @treturn string of branch name or "[No Repo]"
M.get_git_branch = function()
    local branch = vim.b.gitsigns_head
    local icon = ""

    branch = branch and string.format("%s %s", icon, branch) or "[No Repo]"

    return "  " .. branch
end

--- Get wordcount for current buffer
-- @treturn string containing word count
M.get_wordcount_str = function()
    local wc = vim.api.nvim_eval("wordcount()")["words"]

    return string.format("words: %d  ", wc)
end

return M
