local tw_tbl = {
    ["c"] = 88,
    ["cpp"] = 88,
    ["csv"] = 0,
    ["__default"] = 120,
    ["gitcommit"] = 50,
    ["lua"] = 88,
    ["markdown"] = 0,
    ["python"] = 88,
    ["sh"] = 88,
    ["tex"] = 78,
    ["text"] = 0,
}

local M = {

    set_textwidth = function()
        local function hi_long_lines(tw)
            -- cast tw + 1 to str and append %
            local tw_str = "%" .. tw + 1

            -- format matching syntax cmd with tw string
            local err_cmd = string.format([[match Error /\%sv.\+/]], tw_str)

            -- execute
            vim.cmd(err_cmd)
        end

        -- get filetype
        local ft = vim.api.nvim_buf_get_option(0, "filetype")

        -- get desired textwidth from filetype
        local tw = tw_tbl[ft] or tw_tbl["__default"]

        -- set textwidth
        vim.api.nvim_buf_set_option(0, "textwidth", tw)

        if tw > 0 then
            hi_long_lines(tw)
        end
    end,
}

return M
