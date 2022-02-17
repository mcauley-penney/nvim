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
        local function __hi_long_lines(tw)
            -- cast tw + 1 to str and append %
            local tw_str = "%" .. tw + 1

            -- format matching syntax cmd with tw string
            local err_cmd = string.format([[match Error /\%sv.\+/]], tw_str)

            -- execute
            vim.cmd(err_cmd)
        end

        -- get filetype
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        -- get desired textwidth from table
        local tw = tw_tbl[ft] or 0

        -- set textwidth
        vim.api.nvim_buf_set_option(0, "textwidth", tw)

        if tw > 0 then
            __hi_long_lines(tw)
        end
    end,
}

return M
