return {
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			local icons = require("nvim-web-devicons")

			for _, icon in pairs(icons.get_icons()) do
				icon.icon = icon.icon .. ' '
			end

			local def_icon_tbl = icons.get_default_icon()
			def_icon_tbl.icon = def_icon_tbl.icon .. ' '
		end
	}
}
