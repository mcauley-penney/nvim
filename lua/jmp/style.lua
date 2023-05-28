local icons = {
	branch = '',
	bullet = '•',
	ellipses = '┉',
	hamburger = '≡',
	lock = '',
	square = '■'
}

local get_hl = tools.get_hl_grp_rgb
local hl_grp_prefix = "UI"

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
		hi_grps_tbl[name] = tools.make_hl_grp(hl_grp_prefix .. name, {
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
	hl_grps = hl_grp_tbl,
	hl_icons = hl_icons(ui_icons, hl_grp_tbl),
	hl_signs = hl_lsp_icons(signs, hl_grp_tbl),
	no_hl_icons = icons,
	palette = palette
}
