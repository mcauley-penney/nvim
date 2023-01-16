local gra = "NonText"
local grn = "DiagnosticOk"
local red = "DiagnosticError"
local ylw = "DiagnosticWarn"

local signs_tbl = {
	add = {
		hl = grn,
		text = "+",
	},
	change = {
		hl = ylw,
		text = "│",
	},
	changedelete = {
		hl = ylw,
		text = "~",
	},
	delete = {
		hl = red,
		text = "_",
	},
	topdelete = {
		hl = red,
		text = "‾",
	},
  untracked = {
		hl = gra,
		text = '┆'
	},
}

require("gitsigns").setup({
	preview_config = {
		border = require("jmp.ui.init").border,
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},

	signs = signs_tbl,
	signcolumn = false,

	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map('n', '<leader>gd', gs.diffthis)
		map('n', '<leader>gD', function() gs.diffthis('~') end)
		map("n", "<leader>gt", gs.toggle_signs)
		map("n", "<leader>gp", gs.preview_hunk)
		map("n", "<leader>gu", gs.undo_stage_hunk)

		map({ "n", "v" }, "<leader>gs", ':Gitsigns stage_hunk<CR>')
	end
})
