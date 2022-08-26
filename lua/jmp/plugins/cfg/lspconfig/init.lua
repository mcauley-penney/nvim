local lspcfg = "jmp.plugins.cfg.lspconfig."
local on_attach = require(lspcfg .. "on_attach")

for _, mod in ipairs({ "handlers" }) do
  require(lspcfg .. mod)
end

-- TODO: would like to get all servers programatically
local servers = {
  bashls = {},

  -- see $clangd -h, https://clangd.llvm.org/installation and
  -- https://www.reddit.com/r/neovim/comments/vgxvow/comment/id63m9x/?utm_source=share&utm_medium=web2x&context=3
  clangd = {
    cmd = {
      "clangd",
      "-j=6",
      "--all-scopes-completion",
      "--background-index", -- should include a compile_commands.json or .txt
      "--clang-tidy",
      "--completion-style=detailed",
      "--fallback-style=Microsoft",
      "--function-arg-placeholders",
      "--header-insertion-decorators",
      "--header-insertion=never",
      "--limit-results=10",
      "--pch-storage=memory",
      "--query-driver=/usr/include/*", -- TODO: idk if I need this?
      "--suggest-missing-includes",
    },
  },
  jsonls = {},

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

for name, cfg in pairs(servers) do
  cfg.on_attach = on_attach
  require("lspconfig")[name].setup(cfg)
end
