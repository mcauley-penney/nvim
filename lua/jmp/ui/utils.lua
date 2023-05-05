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

function M.make_hl_grp(grp_name, hi)
	vim.api.nvim_set_hl(0, grp_name, hi)

	return table.concat({ "%#", grp_name, "#" }, "")
end

---@private
---@param opts {name: string?, link: boolean?}?
---@param ns integer?
local function get_hl_as_hex(opts, ns)
	ns, opts = ns or 0, opts or {}
	opts.link = opts.link ~= nil and opts.link or false
	local hl = vim.api.nvim_get_hl(ns, opts)
	hl.fg = hl.fg and ('#%06x'):format(hl.fg)
	hl.bg = hl.bg and ('#%06x'):format(hl.bg)
	return hl
end


---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param grp string
---@param attr string?
function M.get_hl_grp_rgb(grp, attr)
	assert(grp, 'cannot get a highlight without specifying a group name')
	local data = get_hl_as_hex({ name = grp })
	if not attr then return data end

	local color = data[attr]
	if not color then
		vim.schedule(function()
			local msg = string.format(
				'failed to get highlight %s for attribute %s\n%s',
				grp,
				attr,
				debug.traceback()
			)

			vim.notify(
				msg,
				vim.log.levels.ERROR
				{ title = string.format('highlight - get(%s)', grp) }
			)
		end)

		return 'NONE'
	end

	return color
end

return M
