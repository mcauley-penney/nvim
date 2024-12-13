return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig.ui.windows").default_options.border = tools.ui.cur_border
      vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      max_concurrent_installers = 20,
      ui = {
        border = tools.ui.cur_border,
        height = 0.8,
        icons = {
          package_installed = tools.ui.icons.bullet,
          package_pending = tools.ui.icons.ellipses,
          package_uninstalled = tools.ui.icons.o_bullet,
        },
      }
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      ensure_installed = {
        "clangd",
        "jsonls",
        "lua_ls",
        "pyright",
        "ts_ls"
      },
      handlers = {
        function(name)
          require("lspconfig")[name].setup {}
        end,
        -- see $clangd -h, https://clangd.llvm.org/installation
        ["clangd"] = function()
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
          }
        end,
        -- https://github.com/sumneko/lua-language-server/blob/f7e0e7a4245578af8cef9eb5e3ec9ce65113684e/locale/en-us/setting.lua
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
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
          }
        }
      end,
        ["ts_ls"] = function()
          init_options = {
            preferences = { includeCompletionsForModuleExports = false }
          }
        end,
        }
      },
    },

  {
    "folke/lazydev.nvim",
    dependencies = "neovim/nvim-lspconfig",
    ft = "lua",
  },

  {
    "onsails/lspkind.nvim",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      local lspkind = require('lspkind')

      for _, tbl in pairs(lspkind.presets) do
        for name, icon in pairs(tbl) do
          tbl[name] = table.concat({ ' ', icon, ' ' })
        end
      end

      lspkind.init({
        preset = "codicons",
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      progress = {
        suppress_on_insert = true,
        display = {
          done_ttl = 2,
          progress_icon = { pattern = "grow_horizontal", period = 0.75 },
          done_style = "NonText",
          group_style = "NonText",
          icon_style = "NonText",
          progress_style = "NonText"
        },
      },
      notification = {
        window = {
          border = tools.ui.cur_border,
          border_hl = "NonText",
          normal_hl = "NonText",
          winblend = 0,
        }
      }
    }
  },
}
