local tools = "lsp.on_attach."
local methods = vim.lsp.protocol.Methods

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client lsp.Client
---@param bufnr integer
return function(client, bufnr)
  local lsp = vim.lsp.buf

  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param desc string
  local function map(mode, lhs, rhs, desc)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  if client.supports_method(methods.textDocument_formatting) then
    map('n', "<leader>f", function() lsp.format({ timeout_ms = 2000 }) end, "Format with LSP")
  end

  -- https://reddit.com/r/neovim/s/eDfG5BfuxW
  if client.supports_method(methods.textDocument_inlayHint) then
    map('n', "<leader>th", function() vim.lsp.inlay_hint(bufnr, nil) end, "[t]oggle inlay [h]ints")
  end

  if client.supports_method(methods.textDocument_hover) then
    --  map("n", "<leader>r", lsp.rename, {})
    map('n', "<leader>r", require(tools .. "rename").rename, "LSP [r]ename")
  end

  if client.supports_method(methods.textDocument_declaration) then
    map('n', "<leader>DE", lsp.declaration, "Go To [DE]claration")
  end

  if client.supports_method(methods.textDocument_hover) then
    map('n', 'K', lsp.hover, "LSP hover")
  end

  if client.supports_method(methods.textDocument_signatureHelp) then
    map('i', "<C-k>", lsp.signature_help, "LSP Signature Help")
  end

  map('n', "[d", function()
    vim.diagnostic.goto_prev({
      buffer = bufnr,
      float = false,
    })
  end, "Previous Diagnostic")

  map('n', "]d", function()
    vim.diagnostic.goto_next({
      buffer = bufnr,
      float = false,
    })
  end, "Next Diagnostic")

  map('n', "<leader>vd", function()
    vim.diagnostic.open_float({
      height = 15,
      width = 50,
    })
  end, "View Diagnostic Float")
end
