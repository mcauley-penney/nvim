local M = {}
local methods = vim.lsp.protocol.Methods

M.servers = {
  -- see $clangd -h, https://clangd.llvm.org/installation
  clangd = {
    cmd = {
      "clangd",
      "-j=6",
      "--all-scopes-completion",
      "--background-index", -- should include a compile_commands.json or .txt
      "--clang-tidy",
      "--cross-file-rename",
      "--completion-style=detailed",
      "--fallback-style=Microsoft",
      "--function-arg-placeholders",
      "--header-insertion-decorators",
      "--header-insertion=never",
      "--limit-results=10",
      "--pch-storage=memory",
      "--query-driver=/usr/include/*",
      "--suggest-missing-includes",
    },
  },
  -- https://github.com/sumneko/lua-language-server/blob/f7e0e7a4245578af8cef9eb5e3ec9ce65113684e/locale/en-us/setting.lua
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = "Both" },
        format = {
          enable = true,
        },
        hint = { enable = true },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
      },
    },
  },
  ts_ls = {
    init_options = {
      preferences = { includeCompletionsForModuleExports = false }
    }
  }
}


--- Sets up LSP keymaps and autocommands for the given buffer.
M.on_attach = function(client, bufnr)
  local lsp = vim.lsp.buf

  --- @param mode string|string[]
  --- @param lhs string
  --- @param rhs string|function
  --- @param desc string
  local function map(mode, lhs, rhs, desc)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map('n', "<leader>vd", function()
    vim.diagnostic.open_float({ border = tools.ui.cur_border, })
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


return M
