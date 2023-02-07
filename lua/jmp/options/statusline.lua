local WS = "  "

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
	buf_info = nil,
	diag = nil,
	git_branch = nil,
	loc = "%l/%-4L ",
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
	"trunc",
	"path",
	"ro",
	"mod",
	"sep",
	"diag",
	"wordcount",
	"loc",
	"pad",
}

local function get_filepath(root, hl_grps)
	if root == nil then return nil end

	return table.concat({
		hl_grps["Muted"],
		vim.fs.dirname(root),
		'/',
		"%*",
		hl_grps["Warn"],
		vim.fs.basename(root),
		'/',
		"%*",
		vim.fn.expand("%r"),
	})
end

--- Create a string containing info for the current git branch
-- @treturn string: branch info
-- alternative, for if we ever stopped using gitsigns:
-- https://www.reddit.com/r/neovim/comments/uz3ofs/heres_a_function_to_grab_the_name_of_the_current/
local function get_git_branch(root, icon_tbl)
	local branch = vim.g.get_git_branch(root)

	return branch and table.concat({ icon_tbl["branch"], " ", branch, " ", ">" })
end

--- Create a string of diagnostic information
-- @tparam lsp_signs: dict of signs used for diagnostics
-- @tparam hl_dict: dict of highlights for statusline
-- @treturn success str: string indicating no diagnostics available
-- @treturn diagnostic str: string indicating diagnostics available
local function get_diag_str(lsp_signs)
	if #vim.diagnostic.get(0) < 1 then
		return table.concat({ lsp_signs["Ok"], WS })
	end

	local count = nil
	local diag_tbl = {}

	for _, type in pairs({ "Error", "Warn", "Info", "Hint" }) do
		count = #vim.diagnostic.get(0, { severity = string.upper(type) })
		vim.list_extend(diag_tbl, { lsp_signs[type], ":", count, WS })
	end

	return table.concat(diag_tbl)
end

--- Get wordcount for current buffer or visual selection
-- @treturn string containing word count
local function get_wordcount_str()
	local wc

	if vim.fn.wordcount().visual_words ~= nil then
		wc = vim.fn.wordcount().visual_words
	else
		wc = vim.fn.wordcount().words
	end

	return string.format("\\w: %d%s", wc, WS)
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
--
-- NOTES:
--  • tracking window status:
--      1. Should avoid autocommands to track current statusline, see
--      https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
--
--      2. Can track via global vars, see
--      https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
--
_G.get_statusline = function()
	local ui = require("jmp.ui")
	local hl_grps_tbl = ui.hl_grps
	local hl_icons_tbl = ui.hl_icons
	local buf_get_opt = vim.api.nvim_buf_get_option

	if vim.bo.buftype == "terminal" then
		return "%#StatusLineNC#"
	end

	local path = vim.api.nvim_buf_get_name(0)
	local root = vim.g.get_path_root(path)
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

	stl_parts["path"] = get_filepath(root, hl_grps_tbl) or path
	stl_parts["git_branch"] = get_git_branch(root, hl_icons_tbl)
	stl_parts["ro"] = buf_get_opt(buf, "readonly") and hl_icons_tbl["readonly"] or ""

	if not buf_get_opt(buf, "modifiable") then
		stl_parts["mod"] = hl_icons_tbl["nomodifiable"]
	elseif buf_get_opt(buf, "modified") then
		stl_parts["mod"] = hl_icons_tbl["modified"]
	else
		stl_parts["mod"] = ""
	end

	if #vim.lsp.buf_get_clients() > 0 then
		stl_parts["diag"] = get_diag_str(ui.hl_signs)
	end

	if vim.g.nonprog_mode[vim.api.nvim_buf_get_option(0, "filetype")] then
		stl_parts["wordcount"] = get_wordcount_str()
	end

	-- turn all of these pieces into one string
	return concat_status(stl_order, stl_parts)
end
