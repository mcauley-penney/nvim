return {
	{
		"stevearc/aerial.nvim",
		config = {
			layout = {
				close_on_select = false,
				max_width = 45,
				min_width = 35,
				close_automatic_events = { "switch_buffer", "unfocus", "unsupported" },
			}
		},
		init = function()
			vim.keymap.set("n", "<F7>", "<cmd>AerialToggle<cr>", { silent = true })
		end
	}
}
