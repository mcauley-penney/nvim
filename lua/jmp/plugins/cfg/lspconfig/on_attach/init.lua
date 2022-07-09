local tools = "jmp.plugins.cfg.lspconfig.on_attach."

local function opts(desc, opts_to_add)
  local defaults = { buffer = 0, desc = desc }

  return vim.tbl_extend("keep", defaults, opts_to_add or {})
end

return function(client, bufnr)
  local lsp = vim.lsp.buf
  local map = vim.keymap.set

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "editing",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
        -- vim.lsp.buf.formatting()
      end,
    })
  end

  if client.supports_method("textDocument/signatureHelp") then
    require(tools .. "auto_signature").setup(client)
  end

  map("n", "E", lsp.hover, opts("LSP Hover"))
  map("i", "<C-e>", lsp.signature_help, opts("LSP Signature Help"))

  map("n", "<leader>D", lsp.type_definition, opts("Go To Type Definition"))
  map("n", "<leader>gD", lsp.declaration, opts("Go To Declaration"))
  map("n", "gd", vim.lsp.buf.definition, opts("Go To Definition"))
  map("n", "gi", vim.lsp.buf.implementation, opts("Go To Implementation"))
  map("n", "<leader>gr", lsp.references, opts("Go To References"))

  map(
    "n",
    "<leader>r",
    require(tools .. "rename").exe_rename,
    opts("LSP Rename")
  )

  map("n", "<up>", function()
    vim.diagnostic.goto_prev({ buffer = 0, float = false })
  end, {})

  map("n", "<down>", function()
    vim.diagnostic.goto_next({ buffer = 0, float = false })
  end, {})

  map("n", "<leader>vd", function()
    vim.diagnostic.open_float({
      height = 15,
      width = 50,
    })
  end, opts("View Diagnostic Float"))
end
