local short_indent = {
	["css"] = true,
	["javascript"] = true,
	["javascriptreact"] = true,
	["json"] = true,
	["lua"] = true,
	["org"] = true,
	["yaml"] = true,
}

local nonstandard_tw = {
	["gitcommit"] = 50,
	["javascript"] = 120,
	["javascriptreact"] = 120,
	["json"] = 0,
	["lua"] = 120,
	["python"] = 120,
}

local M = {
	set_indent = function(ft)
		local indent = short_indent[ft] and 2 or 4

		for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
			vim.api.nvim_buf_set_option(0, opt, indent)
		end
	end,

	set_textwidth = function(ft)
		local tw = nonstandard_tw[ft] or 80

		if tools.nonprog_mode[ft] then
			tw = 0
		end

		vim.api.nvim_buf_set_option(0, "textwidth", tw)
	end,
}

return M
