local utils = require("jmp.ui.status.utils")

local parts = {
	["fold"] = "%C",
	["num"] = nil,
	["sep"] = "%=",
	["signcol"] = "%s",
	["space"] = " "
}

local order = {
	"diag",
	"sep",
	"num",
	"space",
	"gitsigns",
	"fold"
}

local function get_num()
	local cur_num
	local do_indent = false
	local sep = ','

	-- if is current line
	if vim.v.relnum == 0 then
		do_indent = true
		cur_num = vim.v.lnum
	else
		cur_num = vim.v.relnum
	end

	-- if line is wrapped
	if vim.v.virtnum ~= 0 then
		cur_num = '-'
	end

	-- insert thousands separators in line numbers
	-- https://stackoverflow.com/a/42911668
	if type(cur_num) == "number" then
		cur_num = vim.fn.substitute(
			tostring(cur_num),
			'\\d\\zs\\ze\\%(\\d\\d\\d\\)\\+$',
			sep,
			'g'
		)
	end

	return utils.pad_str(cur_num, 4, do_indent, "right" )
end

local function mk_hl(group, sym)
	return table.concat({ "%#", group, "#", sym, "%*" })
end

---@return {name:string, text:string, texthl:string}[]
local function get_signs()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

	return vim.tbl_map(function(sign)
		return vim.fn.sign_getdefined(sign.name)[1]
	end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

local function prepare_sign(sign)
	if sign then
		return mk_hl(sign.texthl, sign.text)
	end

	return "  "
end

_G.get_statuscol = function()
	local str_tbl = {}

	parts["num"] = get_num()

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

	for _, val in ipairs(order) do
		table.insert(str_tbl, parts[val])
	end

	return table.concat(str_tbl)
end
