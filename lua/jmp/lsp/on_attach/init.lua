local tools = "jmp.lsp.on_attach."

local function opts(desc, opts_to_add)
	local defaults = { buffer = 0, desc = desc }

	return vim.tbl_extend("keep", defaults, opts_to_add or {})
end

return function(client, bufnr)
	local lsp = vim.lsp.buf
	local map = vim.keymap.set

	if client.supports_method("textDocument/formatting") then
		map('n', "<leader>f", function()
				lsp.format({ timeout_ms = 2000 })
			end,
			opts("Format with LSP"))
	end

	if client.supports_method("textDocument/rename") then
		map("n", "<leader>r", require(tools .. "rename").rename, {})
	end

	if client.supports_method("textDocument/declaration") then
		map('n', "<leader>DE", lsp.declaration, opts("Go To Declaration"))
	end

	for lhs, rhs in pairs({
		["<leader>D"] = lsp.definition,
		["<leader>R"] = lsp.references,
		["<leader>T"] = lsp.type_definition,
		["<leader>I"] = lsp.implementation
	}) do
		if not vim.fn.maparg(lhs, 'n') then
			vim.keymap.set('n', lhs, rhs, {})
		end
	end

	-- E instead of K because Colemak
	map('n', "K", lsp.hover, opts("LSP Hover"))
	map('i', "<C-k>", lsp.signature_help, opts("LSP Signature Help"))

	map('n', "[?", function()
		vim.diagnostic.goto_prev({ buffer = bufnr, float = false })
	end, {})

	map('n', "]?", function()
		vim.diagnostic.goto_next({ buffer = bufnr, float = false })
	end, {})

	map('n', "<leader>vd", function()
		vim.diagnostic.open_float({
			height = 15,
			width = 50,
		})
	end, opts("View Diagnostic Float"))
end
