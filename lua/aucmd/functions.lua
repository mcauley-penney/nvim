local M = {}

M.hi_long_lines = function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    if ft ~= "csv" then
        -- get textwidth string, cast to an int, and add 1
        local tw_int = tonumber(vim.api.nvim_get_option("textwidth")) + 1

        -- cast tw to str and append %
        local tw_str = "%" .. tostring(tw_int)

        -- format matching syntax cmd with tw string and execute
        vim.cmd(string.format([[match Error /\%sv.\+/]], tw_str))
    end
end

return M
