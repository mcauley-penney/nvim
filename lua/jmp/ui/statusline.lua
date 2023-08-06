local utils = require("jmp.ui.utils")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
	buf_info = nil,
	diag = nil,
	git_info = nil,
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
	"git_info",
	"path",
	"ro",
	"mod",
	"sep",
	"diag",
	"wordcount",
	"pad",
}

local get_hl = tools.get_hl_grp_rgb
local icons = tools.ui.icons

local palette = {
	Error = get_hl("DiagnosticError", "fg"),
	Hint = get_hl("DiagnosticHint", "fg"),
	Info = get_hl("DiagnosticInfo", "fg"),
	Ok = get_hl("DiagnosticOk", "fg"),
	Warn = get_hl("DiagnosticWarn", "fg"),
	Muted = get_hl("Comment", "fg"),
	bg = get_hl("StatusLine", "bg"),
}

local ui_icons = {
	["branch"] = { "Ok", icons["branch"] },
	["nomodifiable"] = { "Warn", icons["bullet"] },
	["modified"] = { "Error", icons["bullet"] },
	["readonly"] = { "Warn", icons["lock"] },
}

local signs = {
	Error = icons["hamburger"],
	Warn = icons["hamburger"],
	Hint = icons["hamburger"],
	Info = icons["hamburger"],
	Ok = icons["hamburger"],
}


local function make_ui_hl_grps(hi_palette)
	local ui_bg = hi_palette["bg"]
	local hi_grps_tbl = {}

	for name, color in pairs(hi_palette) do
		hi_grps_tbl[name] = tools.make_hl_grp("UI" .. name, {
			fg = color,
			bg = ui_bg
		})
	end

	return hi_grps_tbl
end

local function hl_icons(icon_list, hl_grps)
	local hled_icons = {}

	for name, list in pairs(icon_list) do
		hled_icons[name] = tools.hl_str_grpstr(hl_grps[list[1]], list[2])
	end

	return hled_icons
end

local function hl_lsp_icons(lsp_icons, hl_grps)
	local hl_syms = {}
	local sign_hl

	for diag_type, sym in pairs(lsp_icons) do
		sign_hl = table.concat({ "DiagnosticSign", diag_type })
		vim.fn.sign_define(sign_hl, { text = sym, texthl = sign_hl })
		hl_syms[diag_type] = tools.hl_str_grpstr(hl_grps[diag_type], sym)
	end

	return hl_syms
end

local hl_grp_tbl = make_ui_hl_grps(palette)
local ui_hl_grps = hl_grp_tbl
local hl_ui_icons = hl_icons(ui_icons, hl_grp_tbl)
local lsp_signs = hl_lsp_icons(signs, hl_grp_tbl)



--- Create a string containing info for the current git branch
-- @treturn string: branch info
local function get_git_info(root, icon_tbl)
	local remote = tools.get_git_remote_name(root)
	local branch = tools.get_git_branch(root)

	if remote and branch then
		return table.concat({ icon_tbl["branch"], ' ', remote, ':', branch, ' ' })
	end
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
local function get_diag_str(lsp_syms)
	local count = nil
	local count_str = nil
	local diag_tbl = {}

	for _, type in pairs({ "Error", "Warn" }) do
		count = #vim.diagnostic.get(0, { severity = string.upper(type) })
		count_str = utils.pad_str(tostring(count), 3, "left")
		vim.list_extend(diag_tbl, { lsp_syms[type], ' ', count_str })
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
-- See https://github.com/nvimdev/whiskyline.nvim/blob/main/lua/whiskyline/init.lua
-- for async implementation of statusline
_G.get_statusline = function()
	local get_bufopt = vim.api.nvim_buf_get_option

	if vim.bo.buftype == "terminal" then
		return "%#StatusLineNC#"
	end

	local path = vim.api.nvim_buf_get_name(0)
	local root = tools.get_path_root(path)
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

	stl_parts["git_info"] = get_git_info(root, hl_ui_icons)
	stl_parts["path"] = get_filepath(root, ui_hl_grps) or path
	stl_parts["ro"] = get_bufopt(buf, "readonly") and hl_ui_icons["readonly"] or ""

	if not get_bufopt(buf, "modifiable") then
		stl_parts["mod"] = hl_ui_icons["nomodifiable"]
	elseif get_bufopt(buf, "modified") then
		stl_parts["mod"] = hl_ui_icons["modified"]
	else
		stl_parts["mod"] = ""
	end

	if #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 then
		stl_parts["diag"] = get_diag_str(lsp_signs)
	end

	stl_parts["wordcount"] = get_wordcount_str()

	-- turn all of these pieces into one string
	return concat_status(stl_order, stl_parts)
end


vim.o.statusline = "%!v:lua.get_statusline()"
