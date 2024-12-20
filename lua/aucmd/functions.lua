local short_indent = {
  ["css"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["json"] = true,
  ["lua"] = true,
  ["org"] = true,
  ["text"] = true,
  ["yaml"] = true,
}

local nonstandard_tw = {
  ["c"] = 120,
  ["cpp"] = 120,
  ["gitcommit"] = 72,
  ["javascript"] = 120,
  ["javascriptreact"] = 120,
  ["json"] = 0,
  ["lua"] = 120,
  ["markdown"] = 0,
  ["python"] = 120,
  ["tex"] = 0,
  ["plaintex"] = 0,
  ["whsp"] = 0,
  ["txt"] = 0
}

local M = {
  set_indent = function(ft)
    local indent = short_indent[ft] and 2 or 4

    for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
      vim.api.nvim_set_option_value(opt, indent, {})
    end
  end,

  set_textwidth = function(ft)
    local tw = nonstandard_tw[ft] or 80
    tw = tools.nonprog_modes[ft] and 0 or tw

    vim.api.nvim_set_option_value("textwidth", tw, {})
  end,

  --- Sets up LSP keymaps and autocommands for the given buffer.
  on_attach = function(client, bufnr)
    local lsp = vim.lsp.buf
    local methods = vim.lsp.protocol.Methods

    --- @param mode string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param desc string
    local function map(mode, lhs, rhs, desc)
      mode = mode or 'n'
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', "<leader>vd", function()
      local border = table.concat(tools.ui.cur_border)
      vim.diagnostic.open_float({ border = border })
    end, "[v]iew [d]iagnostic float")

    if client.supports_method(methods.textDocument_formatting) then
      map('n', "<leader>f", function() lsp.format({ timeout_ms = 2000 }) end, "[f]ormat with LSP")
    end

    -- https://github.com/neovim/neovim/commit/448907f65d6709fa234d8366053e33311a01bdb9
    -- https://reddit.com/r/neovim/s/eDfG5BfuxW
    if client.supports_method(methods.textDocument_inlayHint) then
      map('n', "<leader>th", function()
        local hint = vim.lsp.inlay_hint
        hint.enable(not hint.is_enabled(bufnr))
      end, "[t]oggle inlay [h]ints")
    end

    if client.supports_method(methods.textDocument_foldingRange) then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client.supports_method(methods.textDocument_rename) then
      map("n", "<leader>r", lsp.rename, "[r]ename")
    end

    if client.supports_method(methods.textDocument_declaration) then
      map('n', "<leader>de", lsp.declaration, "go to [de]claration")
    end

    if client.supports_method(methods.textDocument_hover) then
      map('n', 'K', lsp.hover, "LSP hover")
    end

    if client.supports_method(methods.textDocument_signatureHelp) then
      map('i', "<C-k>", lsp.signature_help, "LSP signature help")
    end
  end
}

return M
