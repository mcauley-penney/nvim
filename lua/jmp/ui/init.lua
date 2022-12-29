local utils = require("jmp.ui.utils")
local get_hi = utils.get_hl_grp_rgb
local hl_grp_prefix = "UI"

local palette = {
	Error = get_hi("DiagnosticError", "fg"),
	Hint = get_hi("DiagnosticHint", "fg"),
	Info = get_hi("DiagnosticInfo", "fg"),
	Ok = get_hi("DiagnosticOk", "fg"),
	Warn = get_hi("DiagnosticWarn", "fg"),
	Muted = get_hi("Comment", "fg"),
	bg = get_hi("StatusLine", "bg"),
}

local icons = {
	["diagnostic"] = "■",
	["fold"] = "⋯",
}

local icons_to_hl = {
	["branch"] = { "Ok", '' },
	["no_branch"] = { "Muted", '' },
	-- ["no_diag"] = { "Ok", '' },
	["modifiable"] = { "Ok", '○' },
	["modified"] = { "Error", '•' },
	["readonly"] = { "Warn", '' },
}

local signs = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = "",
	Ok = ""
}

local function make_ui_hl_grps(hi_palette)
	local ui_bg = hi_palette["bg"]
	local hi_grps_tbl = {}

	for name, color in pairs(hi_palette) do
		hi_grps_tbl[name] = utils.make_hl_grp(hl_grp_prefix .. name, {
			fg = color,
			bg = ui_bg
		})
	end

	return hi_grps_tbl
end

local function hl_icons(icon_list, hl_grps)
	local hled_icons = {}

	for name, list in pairs(icon_list) do
		hled_icons[name] = table.concat({ hl_grps[list[1]], list[2], "%*" })
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

local function hl_lsp_icons(lsp_icons, hl_grps)
	local hl_syms = {}
	local sign_hl

	for diag_type, sym in pairs(lsp_icons) do
		sign_hl = table.concat({ "DiagnosticSign", diag_type })
		vim.fn.sign_define(sign_hl, { text = sym, texthl = sign_hl })

		hl_syms[diag_type] = table.concat({ hl_grps[diag_type], sym, "%*" })
	end

	return hl_syms
end

local hl_grp_tbl = make_ui_hl_grps(palette)

return {
	border = make_invisible_border(),
	hl_grps = hl_grp_tbl,
	hl_icons = hl_icons(icons_to_hl, hl_grp_tbl),
	hl_signs = hl_lsp_icons(signs, hl_grp_tbl),
	no_hl_icons = icons,
}
