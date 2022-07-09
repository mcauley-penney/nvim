local lspcfg = "jmp.plugins.cfg.lspconfig."
local on_attach = require(lspcfg .. "on_attach")

local servers = {
  clangd = {
    cmd = {
      "clangd",
      "--all-scopes-completion",
      "--clang-tidy",
      "--completion-style=detailed",
      "--cross-file-rename",
      "--fallback-style=Microsoft",
      "--header-insertion=never",
      "--header-insertion-decorators",
      "-j=6",
      "--limit-results=10",
      "--pch-storage=memory",
      "--suggest-missing-includes",
    },
  },

  pyright = {},

  -- https://github.com/sumneko/lua-language-server/blob/f7e0e7a4245578af8cef9eb5e3ec9ce65113684e/locale/en-us/setting.lua
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        telemetry = { enable = false },
        workspace = {
          library = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
        format = { enable = true },
      },
    },
  },
}

for _, mod in ipairs({ "handlers" }) do
  require(lspcfg .. mod)
end

for name, cfg in pairs(servers) do
  cfg.on_attach = on_attach
  require("lspconfig")[name].setup(cfg)
end
