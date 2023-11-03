return {
	{
		"akinsho/toggleterm.nvim",
		version = "",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				--  direction = "horizontal",
				float_opts = {
					border = tools.ui.border,
					width = 120,
				},
				highlights = {
					Cursor = { link = "Normal" },
					FloatBorder = { link = 'FloatBorder' },
					Normal = { link = "Normal" },
					NormalFloat = { link = 'NormalFloat' },
					StatusLineNC = { link = "StatusLine" },
					WinBar = { link = "StatusLine" },
				},
				insert_mappings = false,
				open_mapping = [[<C-space>]],
				size = 50
			})

			vim.api.nvim_set_hl(0, "TermCursor", { link = "Cursor" })
		end,
	}
}
