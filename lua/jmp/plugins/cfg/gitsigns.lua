local ui = require("jmp.ui.utils")
local gra = "Nontext"
local grn = "DiagnosticOk"
local red = "DiagnosticError"
local ylw = "DiagnosticWarn"
local sym = '┃'

local sign_tbl = {}
local dim_hl, fg
for grp, hl in pairs({
	Add = grn,
	Change = ylw,
	Changedelete = ylw,
	Delete = red,
	Topdelete = red,
	Untracked = gra,
}) do

	fg = ui.get_hl_grp_rgb(hl, "fg")
	dim_hl = ui.shade_color(fg, -25)
	vim.api.nvim_set_hl(0, "GitSigns" .. grp, { fg = dim_hl })

	sign_tbl[string.lower(grp)] = { text = sym }
end

require("gitsigns").setup({
	_threaded_diff = true,
	_extmark_signs = false,
	_signs_staged_enable = false,
	update_debounce = 500,
	preview_config = {
		border = require("jmp.ui.init").border,
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},

	signs = sign_tbl,
	signcolumn = true,

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
