_G.tools = {}

-- ┌────────┐
-- │settings│
-- └────────┘

-- defines what filetypes should not be treated like source code
tools.nonprog_mode = {
	["markdown"] = true,
	["org"] = true,
	["orgagenda"] = true,
	["text"] = true,
}


-- ┌─────────┐
-- │functions│
-- └─────────┘
--------------------------------------------------
-- project directories
--------------------------------------------------
-- provides a place to cache the root
-- directory for current editing session
local branch_cache = {}

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
tools.get_path_root = function(path)
	if path == "" then return end

	local root = vim.b.path_root
	if root ~= nil then return root end

	local root_items = {
		".git"
	}

	root = vim.fs.find(root_items, {
		path = path,
		upward = true,
		type = "directory"
	})[1]
	if root == nil then return nil end

	root = vim.fs.dirname(root)
	vim.b.path_root = root

	return root
end

tools.get_git_branch = function(root)
	if root == nil then return end

	local branch = branch_cache[root]
	if branch ~= nil then return branch end

	local cmd = table.concat({ "git", "-C", root, "branch --show-current" }, " ")
	branch = vim.fn.system(cmd)
	if branch == nil then return nil end

	branch = branch:gsub("\n", "")
	branch_cache[root] = branch

	return branch
end

--------------------------------------------------
-- Highlights
--------------------------------------------------
tools.make_hl_grp_str = function(grp_name)
	return table.concat({ "%#", grp_name, "#" }, "")
end

tools.make_hl_grp = function(grp_name, hi)
	vim.api.nvim_set_hl(0, grp_name, hi)
	return tools.make_hl_grp_str(grp_name)
end

tools.highlight_text = function(grp_name, text)
	local hl_grp_str = tools.make_hl_grp_str(grp_name)
	return table.concat({hl_grp_str, text, "%*"})
end


-- Stolen from toggleterm.nvim
--
---Convert a hex color to an rgb color
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
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
tools.shade_color = function(color, percent)
	local r, g, b = hex_to_rgb(color)

	-- If any of the colors are missing return "NONE" i.e. no highlight
	if not r or not g or not b then return "NONE" end

	r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
	g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
	b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
	r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

	return "#" .. string.format("%02x%02x%02x", r, g, b)
end


---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param grp string
---@param attr string?
tools.get_hl_grp_rgb = function(grp, attr)
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


	assert(grp, 'cannot get a highlight without specifying a group name')
	local hl_tbl = get_hl_as_hex({ name = grp })
	if not attr then return hl_tbl end

	local hex_color = hl_tbl[attr]
	if not hex_color then
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

	return hex_color
end
