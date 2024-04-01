return {
	{
		"gbprod/substitute.nvim",
		opts = {
			highlight_substituted_text = {
				timer = 200,
			},
			range = {
				group_substituted_text = false,
				prefix = "s",
				prompt_current_text = false,
				suffix = "",
			},
		},
		init = function()
			vim.keymap.set("n", "r", require("substitute").operator, {})
			vim.keymap.set("n", "rr", require("substitute").line, {})
			vim.keymap.set("n", "R", require("substitute").eol, {})
			vim.keymap.set("x", "r", require("substitute").visual, {})

			vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
			vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
		end,
	}
}
