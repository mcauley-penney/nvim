return {
	{
		"jbyuki/venn.nvim",
		config = function()
			vim.keymap.set("n", "<S-down>", "<C-v>j:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-up>", "<C-v>k:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-left>", "<C-v>h:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-right>", "<C-v>l:VBox<CR>", { noremap = true })
			vim.keymap.set("v", "<leader>b", ":VBox<CR>", { noremap = true })
		end
	}
}
