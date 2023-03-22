local M = {}

-- Stolen from toggleterm.nvim
--
---Convert a hex color to an rgb color
---@param color string
---@return number
---@return number
---@return number
local function to_rgb(color)
	return tonumber(color:sub(2, 3), 16),
			tonumber(color:sub(4, 5), 16),
			tonumber(color:sub(6), 16)
end

-- Stolen from toggleterm.nvim
--
-- SOURCE: https://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
-- @see: https://stackoverflow.com/questions/37796287/convert-decimal-to-hex-in-lua-4
--- Shade Color generate
--- @param color string hex color
--- @param percent number
--- @return string
function M.shade_color(color, percent)
	local r, g, b = to_rgb(color)

	-- If any of the colors are missing return "NONE" i.e. no highlight
	if not r or not g or not b then return "NONE" end

	r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
	g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
	b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
	r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

	return "#" .. string.format("%02x%02x%02x", r, g, b)
end

--- get rgb str from highlight group name
--- @param  hi: highlight group name, e.g. Special
--- @param  type: background or foreground
M.get_hl_grp_rgb = function(grp, type)
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
end

function M.make_hl_grp(grp_name, hi)
	vim.api.nvim_set_hl(0, grp_name, hi)

	return table.concat({ "%#", grp_name, "#" }, "")
end

return M
