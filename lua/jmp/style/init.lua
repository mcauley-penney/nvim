local utils = require("jmp.style.utils")
local get_hi = utils.get_hl_grp_rgb

local make_invisible_border = function()
	local border = {}
	local required_border_len = 8

	while #border < required_border_len do
		table.insert(border, { " ", "FloatBorder" })
	end

	return border
end

local make_lsp_palette_groups = function(palette)
	local hl_dict = {}
	local name

	for type, hex_str in pairs(palette) do
		hl_dict[type] = {}

		name = "UI" .. type

		hl_dict[type].name = name

		hl_dict[type].hl_str = utils.make_hl_grp(name, {
			fg = hex_str,
			bg = palette["bg"]
		})
	end

	return hl_dict
end

local style = {
	["border"] = make_invisible_border(),
	["palette"] = {
		Error = get_hi("DiagnosticError", "fg"),
		Failure = get_hi("Comment", "fg"),
		Hint = get_hi("DiagnosticHint", "fg"),
		Info = get_hi("DiagnosticInfo", "fg"),
		Success = get_hi("Success", "fg"),
		Warn = get_hi("DiagnosticWarn", "fg"),
		bg = get_hi("StatusLine", "bg"),
	},
	["signs"] = {
		Error = " ",
		Warn = " ",
		Info = " ",
		Hint = "",
	},
	["icons"] = {
		["branch"] = "",
		["diagnostic"] = "■",
		["fold"] = "",
		["mod"] = "•",
		["ro"] = "",
	},
}

style["palette_grps"] = make_lsp_palette_groups(style["palette"])

return style
