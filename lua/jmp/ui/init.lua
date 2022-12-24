local utils = require("jmp.ui.utils")
local get_hi = utils.get_hl_grp_rgb

local palette_grps = {
	Error = get_hi("DiagnosticError", "fg"),
	Hint = get_hi("DiagnosticHint", "fg"),
	Info = get_hi("DiagnosticInfo", "fg"),
	Success = get_hi("@string.regex", "fg"),
	Warn = get_hi("DiagnosticWarn", "fg"),
	bg = get_hi("StatusLine", "bg"),
}

local icons = {
	["diagnostic"] = "■",
	["fold"] = "⋯",
}

local icons_to_hl = {
	["branch"] = { fg = "Success", sym = '' },
	["no_branch"] = { fg = "Error", sym = 'ﱮ' },
	["no_diag"] = { fg = "Success", sym = '' },
	["modifiable"] = { fg = "Success", sym = '○' },
	["modified"] = { fg = "Error", sym = '•' },
	["readonly"] = { fg = "Warn", sym = '' },
}

local signs = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = "",
}


local function hl_icons(icon_tbl, palette)
	local hled_icons = {}

	for name, tbl in pairs(icon_tbl) do
		local hl_grp = utils.make_hl_grp("UI".. tbl["fg"],{
			fg = palette[tbl["fg"]],
			bg = palette["bg"]
		})

		tbl = vim.list_extend(tbl, { "%*" })
		hled_icons[name] = table.concat({hl_grp, tbl["sym"], "%*"})
	end

	return hled_icons
end

local make_invisible_border = function()
	local border = {}
	local required_border_len = 8

	while #border < required_border_len do
		table.insert(border, { " ", "FloatBorder" })
	end

	return border
end

local custom_border = make_invisible_border()

local function hl_lsp_icons(lsp_icons, palette)
	local hl_syms = {}
	local hl_str
	local name
	local sign_hl

	for diag_type, sym in pairs(lsp_icons) do
		-- define signs for sign col
		sign_hl = table.concat({ "DiagnosticSign", diag_type })
		vim.fn.sign_define(sign_hl, { text = sym, texthl = sign_hl })

		-- define hl group for ui and concat with sign
		name = "UI" .. diag_type

		hl_str = utils.make_hl_grp(name, {
			fg = palette[diag_type],
			bg = palette["bg"]
		})

		hl_syms[diag_type] = table.concat({ hl_str, sym, "%*" })
	end

	return hl_syms
end

vim.diagnostic.config({
	float = {
		border = custom_border,
		header = "",
		severity_sort = true,
	},
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	virtual_text = {
		format = function(diag)
			local prefix = icons.diagnostic
			local msg = string.gsub(diag.message, "%s*%c+%s*", ":")
			return string.format("%s [%s] %s", prefix, diag.source, msg)
		end,
		prefix = "",
	},
})

return {
	border = custom_border,
	hl_icons = hl_icons(icons_to_hl, palette_grps),
	hl_signs = hl_lsp_icons(signs, palette_grps),
	no_hl_icons = icons,
}
