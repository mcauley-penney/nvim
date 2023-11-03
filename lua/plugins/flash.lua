-- Navigation with jump motions.
return {
	{
		'folke/flash.nvim',
		opts = {
			prompt = {
				win_config = { row = -3 },
			},
			modes = {
				jump = {
					autojump = true,
					nohlsearch = true,
				},
				search = {
					exclude = {
						'cmp_menu',
						'flash_prompt',
						'qf',
						function(win)
							return not vim.api.nvim_win_get_config(win).focusable
						end,
					},
				},
				char = {
					enabled = false,
				},
			},
			label = {
				uppercase = false,
			}
		},
		init = function()
			vim.keymap.set({ 'n', 'x', 'o' }, '<F6>', function() require('flash').jump() end, { desc = 'Flash' })
		end,
	},
}
