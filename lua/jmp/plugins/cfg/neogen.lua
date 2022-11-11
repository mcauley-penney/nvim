require("neogen").setup({
	enabled = true,
	languages = {
		lua = {
			template = {
				annotation_convention = "ldoc",
			},
		},
		python = {
			template = {
				annotation_convention = "google_docstrings",
			},
		},
	},
})

vim.keymap.set("n", "<leader>id", require('neogen').generate, {})
