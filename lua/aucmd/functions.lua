local tw_tbl = {
    ["c"] = 88,
    ["cpp"] = 88,
    ["__default"] = 120,
    ["gitcommit"] = 50,
    ["lua"] = 88,
    ["python"] = 88,
    ["sh"] = 88,
    ["tex"] = 78,
    ["text"] = 120,
}

local M = {

    hi_long_lines = function()
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        if ft ~= "csv" then
            -- get textwidth string, cast to an int, and add 1
            local tw = vim.api.nvim_buf_get_option(0, "textwidth") + 1

            -- cast tw to str and append %
            local tw_str = "%" .. tostring(tw)

            -- format matching syntax cmd with tw string and execute
            vim.cmd(string.format([[match Error /\%sv.\+/]], tw_str))
        end
    end,

    set_textwidth = function()
        local tw = tw_tbl[vim.api.nvim_buf_get_option(0, "filetype")]

        if tw == nil then
            tw = tw_tbl["__default"]
        end

        vim.api.nvim_buf_set_option(0, "textwidth", tw)
    end,
}

return M
