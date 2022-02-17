local M = {

    --- get rgb str from highlight group name
    -- @tparam  hi: highlight group name, e.g. Special
    -- @tparam  type: background or foreground
    get_hi_grp_rgb = function(hi, type)
        -- retrieve table of hi info
        local rgb_tbl = vim.api.nvim_get_hl_by_name(hi, true)

        if type == "fg" then
            return string.format("#%06x", rgb_tbl.foreground)
        elseif type == "bg" then
            return string.format("#%06x", rgb_tbl.background)
        end
    end,
}

return M
