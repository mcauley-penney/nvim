return {
	{
		"rrethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				delay = 150,
				modes_denylist = { 'v' },
				providers = { 'regex' },
				under_cursor = false,
			})
		end,

		init = function()
			for _, type in ipairs({ "Text", "Read", "Write" }) do
				vim.api.nvim_set_hl(0, "IlluminatedWord" .. type, { link = "CursorLine" })
			end
		end
	}
}
