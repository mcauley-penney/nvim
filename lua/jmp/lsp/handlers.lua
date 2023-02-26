local custom_border = require("jmp.ui").border

-- TODO: see
-- https://github.com/ray-x/lsp_signature.nvim/blob/aea1e060d465fcb565bc1178e4189fc79524ba61/lua/lsp_signature/init.lua#L161
-- for how to stylize the markdown in signature

-- https://github.com/askfiy/nvim/blob/74c4a2e1f03e7940c4efcc69d2d4eab736dbc7d3/lua/configure/plugins/nv_nvim-lsp-installer.lua
local lsp_signature_help = function(_, result, ctx, config)
	local bufnr, winnr = vim.lsp.handlers.signature_help(_, result, ctx, config)

	if not bufnr or not winnr then
		return
	end

	-- need the current cursor pos and the height of the window
	-- to determine how to position the documentation float
	local cur_cursor_ln = vim.api.nvim_win_get_cursor(0)[1]
	local win_height = vim.api.nvim_win_get_height(winnr)

	-- By default, place float one line above the current
	-- line and one col to the right of the cursor
	local anchor_pos = "SW"
	local row_num = 0

	-- If too close to the top of the buffer put docs below the current line
	if cur_cursor_ln < win_height + 2 then
		anchor_pos = "NW"
		row_num = 1
	end

	vim.api.nvim_win_set_config(winnr, {
		anchor = anchor_pos,
		border = custom_border,
		relative = "cursor",
		row = row_num,
		col = 1,
		width = 80,
	})

	return bufnr, winnr
end


-- override handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers["hover"],
	{ border = custom_border }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	lsp_signature_help,
	{
		close_events = { "InsertLeavePre" },
		focus = false,
		silent = true,
	}
)
