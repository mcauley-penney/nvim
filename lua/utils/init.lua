local M = {

    get_hi_grp_rgb = function(hi)
        -- retrieve table of hi info
        local rgb_tbl = vim.api.nvim_get_hl_by_name(hi, true)

        for type, rgb in pairs(rgb_tbl) do
            rgb_tbl[type] = "#" .. string.format("%06x", rgb)
        end

        return rgb_tbl
    end,
}

return M
