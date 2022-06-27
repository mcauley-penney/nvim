local std = 80

local tw_tbl = {
    ["c"] = std,
    ["cpp"] = std,
    ["gitcommit"] = 50,
    ["lua"] = std,
    ["python"] = std,
    ["sh"] = std,
}

local M = {
    set_textwidth = function()
        -- get filetype
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        -- set textwidth
        vim.api.nvim_buf_set_option(0, "textwidth", tw_tbl[ft] or 0)
    end,
}

return M
