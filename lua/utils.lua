-- TODO: modularize
local M = {

    --------------------------------------------------
    -- highlights
    --------------------------------------------------
    --- get rgb str from highlight group name
    --- @tparam  hi: highlight group name, e.g. Special
    --- @tparam  type: background or foreground
    get_hl_grp_rgb = function(grp, type)
        local _get_hl_rgb_str = function(hl_num)
            return string.format("#%06x", hl_num)
        end

        -- retrieve table of hi info
        local hl_tbl = vim.api.nvim_get_hl_by_name(grp, true)

        if type == "fg" then
            return _get_hl_rgb_str(hl_tbl.foreground)
        elseif type == "bg" then
            return _get_hl_rgb_str(hl_tbl.background)
        end
    end,

    make_hl_grp_str = function(hi_tbl)
        local hi_cmd = string.format(
            "hi %s gui=%s guibg=%s guifg=%s",
            hi_tbl.grp,
            hi_tbl.gui or "none",
            hi_tbl.bg,
            hi_tbl.fg
        )

        -- instantiate new hl group
        vim.cmd(hi_cmd)

        return table.concat({ "%#", hi_tbl.grp, "#" }, "")
    end,

    --------------------------------------------------
    -- map
    --------------------------------------------------
    map = vim.keymap.set,
    cmd = { noremap = true, silent = true },
    expr = { expr = true, silent = true },
    nore = { noremap = true },

    --------------------------------------------------
    -- validation
    --------------------------------------------------
    --- Check if a cmd is executable
    --- @param exe_str string
    --- @return boolean
    is_exe = function(exe_str)
        return vim.fn.executable(exe_str) > 0
    end,
}

return M
