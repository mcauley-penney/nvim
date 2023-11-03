return {
	{
		"itchyny/vim-highlighturl",
		init = function()
			vim.api.nvim_set_hl(0, "HighlightUrl", { link = "@text.uri" })
		end
	}
}
