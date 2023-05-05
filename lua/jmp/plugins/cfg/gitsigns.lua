local ui = require("jmp.ui.utils")
local set_hl = vim.api.nvim_set_hl

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
	set_hl(0, "GitSigns" .. grp, { fg = dim_hl })

	sign_tbl[string.lower(grp)] = { text = sym }
end


local diffadd_bg = ui.get_hl_grp_rgb("DiffAdd", "bg")
local diffrm_bg = ui.get_hl_grp_rgb("DiffDelete", "bg")

local diffadd_lighter = ui.shade_color(diffadd_bg, 75)
local diffrm_lighter = ui.shade_color(diffrm_bg, 75)

set_hl(0, "GitSignsAddInline", {link = "DiffAdd"})
set_hl(0, "GitSignsAddLnInline", {fg = "fg", bg = diffadd_lighter})
set_hl(0, "GitSignsChangeInline", {link = "DiffText"})
set_hl(0, "GitSignsChangeLnInline", {link = "DiffChange"})
set_hl(0, "GitSignsDeleteInline", {link = "DiffDelete"})
set_hl(0, "GitSignsDeleteLnInline", {fg = "fg", bg = diffrm_lighter})

require("gitsigns").setup({
	-- see https://github.com/akinsho/dotfiles/blob/83040e0d929bcdc56de82cfd49a0b9110603ceee/.config/nvim/plugin/statuscolumn.lua#L58-L72
	_extmark_signs = false,
	_inline2 = true,
	_signs_staged_enable = false,
	_threaded_diff = true,
	preview_config = {
		border = "single",
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
	signs = sign_tbl,
	signcolumn = true,
	update_debounce = 500,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map('n', '<leader>gb', function() gs.blame_line({ full = true }) end)
		map('n', '<leader>gd', gs.diffthis)
		map('n', '<leader>gD', function() gs.diffthis('~') end)
		map("n", "<leader>gt", gs.toggle_signs)
		map("n", "<leader>hp", gs.preview_hunk_inline)
		map("n", "<leader>hu", gs.undo_stage_hunk)

		map({ "n", "v" }, "<leader>hs", ':Gitsigns stage_hunk<CR>')
		map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')

		for map_str, fn in pairs({
			["]h"] = gs.next_hunk,
			["[h"] = gs.prev_hunk
		}) do
			map('n', map_str, function()
				if vim.wo.diff then return map_str end
				vim.schedule(function() fn() end)
				return '<Ignore>'
			end, { expr = true })
		end
	end
})
