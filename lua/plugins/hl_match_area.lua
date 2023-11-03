return {
	{
		"rareitems/hl_match_area.nvim",
		config = {
			highlight_in_insert_mode = false,
		},
		init = function()
			vim.api.nvim_set_hl(0, "MatchArea", { link = "Visual" })
		end
	}
}
