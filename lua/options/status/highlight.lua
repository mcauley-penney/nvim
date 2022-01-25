local M = {

    create_hi_grp_str = function(hi_tbl)
        local hi_cmd = string.format(
            "hi %s gui=%s guibg=%s guifg=%s",
            hi_tbl.grp,
            hi_tbl.gui or "none",
            hi_tbl.bg,
            hi_tbl.fg
        )

        -- instantiate new hi group
        vim.cmd(hi_cmd)

        return table.concat({ "%#", hi_tbl.grp, "#" }, "")
    end,
}

return M
