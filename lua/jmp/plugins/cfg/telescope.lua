local hl_utils = require("jmp.ui.utils")
local norm_hl = hl_utils.get_hl_grp_rgb("Normal", "bg")
local dark_norm = hl_utils.shade_color(norm_hl, -30)

local builtin = require('telescope.builtin')

require('telescope').setup({
	defaults = {
		border = true,
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		layout_strategy = "bottom_pane",
		layout_config = {
			prompt_position = "top",
			height = 30,
			width = 1,
		},
		sorting_strategy = "ascending",
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		undo = {
			diff_context_lines = 10,
			mappings = {
				i = {
					["<cr>"] = require("telescope-undo.actions").restore,
					["<C-cr>"] = require("telescope-undo.actions").yank_additions,
					["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
				},
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true
		},
	}
})

for _, ext in ipairs({ "fzf", "live_grep_args", "undo" }) do
	require('telescope').load_extension(ext)
end

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("Telescope", { clear = true }),
	callback = function()
		builtin.quickfix()
	end
})

vim.api.nvim_create_user_command("Highlights", function()
	builtin.highlights()
end, {})

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = dark_norm })

vim.keymap.set("n", "<C-t>", builtin.find_files, { silent = true })
vim.keymap.set("n", "<C-q>", builtin.quickfix, { silent = true })
vim.keymap.set("n", "\\", builtin.buffers, { silent = true })

vim.keymap.set("n", "<C-f>",
	require('telescope').extensions.live_grep_args.live_grep_args,
	{ silent = true })

vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { silent = true })
