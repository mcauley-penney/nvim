-- TODO: See Akinsho's cfg for how to handle extmarks
-- will become important if Gitsigns transitions to it fully
-- https://github.com/akinsho/dotfiles/blob/1a58db83707c4cd989bca7d730b1c80ab489bc2c/.config/nvim/plugin/statuscolumn.lua

local utils = require("ui.utils")

local parts = {
	["fold"] = nil,
	["num"] = nil,
	["sep"] = "%=",
	["signcol"] = "%s",
	["space"] = " "
}

local order = {
	"diag",
	"sep",
	"num",
	"gitsigns",
	"fold",
	"space"
}


local fcs = vim.opt.fillchars:get()

-- Stolen from Akinsho, modded by me
local function get_fold(lnum)
	local foldlvl = vim.fn.foldlevel

	if foldlvl(lnum) <= foldlvl(lnum - 1) or vim.v.virtnum ~= 0 then
		return ' '
	end

	local fold_sym = vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose

	return tools.hl_str_grpname("Folded", fold_sym)
end

local function get_lnum()
	local cur_num
	local sep = ','

	-- return a visual placeholder if line is wrapped
	if vim.v.virtnum ~= 0 then return '-' end

	-- get absolute lnum if is current line, else relnum
	cur_num = vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum

	-- insert thousands separators in line numbers
	-- viml regex: https://stackoverflow.com/a/42911668
	-- lua pattern: stolen from Akinsho
	cur_num = tostring(cur_num):reverse():gsub('(%d%d%d)', '%1' .. sep):reverse():gsub('^,', '')

	return utils.pad_str(cur_num, 3, "right")
end

---@return {name:string, text:string, texthl:string}[]
local function get_signs()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

	return vim.tbl_map(function(sign)
		return vim.fn.sign_getdefined(sign.name)[1]
	end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

local function prepare_sign(sign)
	return sign and tools.hl_str_grpname(sign.texthl, sign.text) or "  "
end

_G.get_statuscol = function()
	local str_tbl = {}

	parts["num"] = get_lnum()

	local diag_sign, git_sign
	for _, sign_tbl in ipairs(get_signs()) do
		if sign_tbl.name:find("GitSign") then
			git_sign = sign_tbl
		elseif sign_tbl.name:find("DiagnosticSign") and diag_sign == nil then
			diag_sign = sign_tbl
		end
	end

	parts["diag"] = prepare_sign(diag_sign)
	parts["gitsigns"] = prepare_sign(git_sign)
	parts["fold"] = get_fold(vim.v.lnum)

	for _, val in ipairs(order) do
		table.insert(str_tbl, parts[val])
	end

	return table.concat(str_tbl)
end


--  vim.o.statuscolumn = "%!v:lua.get_statuscol()"
