local std = 80

local indent_tbl = {
	["css"] = 2,
	["lua"] = 2,
	["org"] = 2,
}

local tw_tbl = {
	["c"] = std,
	["cpp"] = std,
	["gitcommit"] = 50,
	["lua"] = std,
	["python"] = std,
	["sh"] = std,
}

local M = {
	set_indent = function(ft)
		local indent = indent_tbl[ft]

		for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
			vim.api.nvim_buf_set_option(0, opt, indent or 4)
		end
	end,

	set_textwidth = function(ft)
		-- set textwidth
		vim.api.nvim_buf_set_option(0, "textwidth", tw_tbl[ft] or 0)
	end,
}

return M
