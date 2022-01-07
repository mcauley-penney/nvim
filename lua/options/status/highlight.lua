local M = {}

M.create_hi_grp_str = function(hi_tbl)
    local hi_cmd = string.format(
        "hi %s guibg=%s guifg=%s",
        hi_tbl.grp,
        hi_tbl.bg,
        hi_tbl.fg
    )

    -- instantiate new hi group
    vim.cmd(hi_cmd)

    return "%#" .. hi_tbl.grp .. "#"
end

-- Return a highlight group property as rgb.
-- @param hi: name of a highlight group, e.g. "Normal"
-- @return hexadecimal value str or empty str
M.get_hl_by_name = function(hi, out_type)
    -- retrieve table of hi info from hl name param
    local color_tbl = vim.api.nvim_get_hl_by_name(hi, true)

    -- default to retrieving fg
    local field = color_tbl.foreground

    -- unless type flag == "bg"
    if out_type == "bg" then
        field = color_tbl.background
    end

    -- if the desired field is not null
    if field ~= nil then
        -- return it formatted as RGB in a str that the statusline understands
        return "#" .. string.format("%06x", field)
    else
        -- return empty str
        return ""
    end
end

return M
