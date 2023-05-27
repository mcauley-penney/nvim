local utils = require("jmp.ui.utils")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
	buf_info = nil,
	diag = nil,
	git_branch = nil,
	modifiable = nil,
	modified = nil,
	pad = " ",
	path = nil,
	ro = nil,
	sep = "%=",
	trunc = "%<"
}

local stl_order = {
	"pad",
	"git_branch",
	"path",
	"ro",
	"mod",
	"sep",
	"diag",
	"wordcount",
	"pad",
}

--- Create a string containing info for the current git branch
-- @treturn string: branch info
local function get_git_branch(root, icon_tbl)
	local branch = tools.get_git_branch(root)

	return branch and table.concat({ icon_tbl["branch"], ' ', branch, ' ' })
end

local function get_filepath(root, hl_grps)
	if root == nil then return nil end

	local cols = math.floor(vim.api.nvim_get_option("columns") / 4)

	local root_grp = table.concat({
		"%.",
		cols,
		'(',
		hl_grps["Muted"],
		vim.fs.dirname(root),
		"%)",
		'/',
		"%*"
	})

	local trunk_grp = table.concat({
		hl_grps["Warn"],
		vim.fs.basename(root),
		'/',
		"%*",
	})

	return table.concat({
		root_grp,
		trunk_grp,
		stl_parts["trunc"],
		vim.fn.expand("%r"),
	})
end

--- Create a string of diagnostic information
-- @tparam lsp_signs: dict of signs used for diagnostics
-- @treturn diagnostic str: string indicating diagnostics available
local function get_diag_str(lsp_signs)
	local count = nil
	local diag_tbl = {}

	for _, type in pairs({ "Error", "Warn" }) do
		count = #vim.diagnostic.get(0, { severity = string.upper(type) })
		local count_str = utils.pad_str(tostring(count), 3, "left")
		vim.list_extend(diag_tbl, { lsp_signs[type], ":", count_str })
	end

	return table.concat(diag_tbl)
end

--- Get wordcount for current buffer or visual selection
-- @treturn string containing word count
local function get_wordcount_str()
	local lc = "%L lines"
	local ft = vim.api.nvim_buf_get_option(0, "filetype")

	if not tools.nonprog_mode[ft] then
		return lc
	end

	local wc
	local wc_table = vim.fn.wordcount()

	if wc_table.visual_words and wc_table.visual_chars then
		local cc
		wc = wc_table.visual_words
		cc = wc_table.visual_chars

		return string.format("%d chars, %d words, %s", cc, wc, lc)
	end

	wc = wc_table.words

	return string.format("%d words, %s", wc, lc)
end

-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function concat_status(order_tbl, stl_part_tbl)
	local str_table = {}

	for _, val in ipairs(order_tbl) do
		table.insert(str_table, stl_part_tbl[val])
	end

	return table.concat(str_table, " ")
end

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
_G.get_statusline = function()
	local ui = require("jmp.style")
	local hl_grps_tbl = ui.hl_grps
	local hl_icons_tbl = ui.hl_icons
	local get_bufopt = vim.api.nvim_buf_get_option

	if vim.bo.buftype == "terminal" then
		return "%#StatusLineNC#"
	end

	local path = vim.api.nvim_buf_get_name(0)
	local root = tools.get_path_root(path)
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

	stl_parts["git_branch"] = get_git_branch(root, hl_icons_tbl)
	stl_parts["path"] = get_filepath(root, hl_grps_tbl) or path
	stl_parts["ro"] = get_bufopt(buf, "readonly") and hl_icons_tbl["readonly"] or ""

	if not get_bufopt(buf, "modifiable") then
		stl_parts["mod"] = hl_icons_tbl["nomodifiable"]
	elseif get_bufopt(buf, "modified") then
		stl_parts["mod"] = hl_icons_tbl["modified"]
	else
		stl_parts["mod"] = ""
	end

	if #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 then
		stl_parts["diag"] = get_diag_str(ui.hl_signs)
	end

	stl_parts["wordcount"] = get_wordcount_str()

	-- turn all of these pieces into one string
	return concat_status(stl_order, stl_parts)
end


vim.o.statusline = "%!v:lua.get_statusline()"
