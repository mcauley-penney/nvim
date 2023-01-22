local parts = {
	["fold"] = "%C",
	["num"] = "%{v:wrap? '-': (v:relnum?v:relnum:v:lnum)}",
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
