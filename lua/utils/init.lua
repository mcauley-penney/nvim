local M = {}

M.get_hl_by_name = function(hi, out_type)
    -- retrieve table of hi info from hl name param
    local color_tbl = vim.api.nvim_get_hl_by_name(hi, true)
    local field = nil

    -- unless type flag == "bg"
    if out_type == "bg" then
        field = color_tbl.background
    else
        field = color_tbl.foreground
    end

    -- if the desired field is not null
    if field ~= nil then
        -- return it formatted as RGB in a str that the statusline understands
        return "#" .. string.format("%06x", field)
    else
        -- return empty str
        -- TODO: not exactly useful
        return ""
    end
end

return M
