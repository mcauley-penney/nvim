local on_attach = require("lsp.on_attach")

local servers = {
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
          defaultConfig = {
            indent_style = "tab",
            indent_size = '2',
          }
        },
        hint = { enable = true },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
      },
    },
  },
  tsserver = {
    init_options = {
      preferences = { includeCompletionsForModuleExports = false }
    }
  }
}


local populate_setup = function(servers_tbl, attach_fn)
  local server_setup = function(server_name, server_cfg, attach)
    server_cfg.on_attach = attach
    --  server_cfg.hints = { enabled = true }

    local caps = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
      require('cmp_nvim_lsp').default_capabilities(),
      {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true
            }
          },
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        },
      }
    )

    server_cfg.capabilities = caps

    require("lspconfig")[server_name].setup(server_cfg)
  end


  local setup_tbl = {
    function(server_name)
      server_setup(server_name, {}, attach_fn)
    end
  }

  for name, cfg in pairs(servers_tbl) do
    setup_tbl[name] = function()
      server_setup(name, cfg, attach_fn)
    end
  end

  return setup_tbl
end

require("mason-lspconfig").setup_handlers(populate_setup(servers, on_attach))


vim.diagnostic.config({
  underline = true,
  float = {
    header = "",
    source = 'if_many',
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local severity = vim.diagnostic.severity[diag.severity]
      local level = severity:sub(1, 1) .. severity:sub(2):lower()
      local prefix = string.format(" %s  ", tools.ui.lsp_signs[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
  virtual_text = {
    prefix = '',
    format = function(diag)
      local severity = vim.diagnostic.severity[diag.severity]
      severity = severity:sub(1, 1) .. severity:sub(2):lower()
      local icon = tools.ui.lsp_signs[severity]
      local message = vim.split(diag.message, '\n')[1]
      return string.format('%s %s ', icon, message)
    end,
  },
  severity_sort = true,
})
