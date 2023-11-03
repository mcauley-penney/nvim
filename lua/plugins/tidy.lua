return {
	{
		"mcauley-penney/tidy.nvim",
		opts = {
			filetype_exclude = { "diff" }
		},
		init = function()
			vim.keymap.set('n', "<leader>te", require("tidy").toggle, {})
		end
	}
}
