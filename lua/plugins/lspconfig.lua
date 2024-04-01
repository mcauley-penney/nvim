return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig.ui.windows").default_options.border = tools.ui.cur_border
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
  end,
  dependencies = {
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
      opts = {
        ensure_installed = {
          "clangd",
          "dockerls",
          "jsonls",
          "lua_ls",
          "pyright",
          "tsserver"
        },
      }
    },

    {
      "nvimtools/none-ls.nvim",
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {
        debounce = 300,
        on_attach = require("lsp.on_attach"),
      }
    },

    {
      'jay-babu/mason-null-ls.nvim',
      opts = {
        automatic_installation = true,
        ensure_installed = {
          "actionlint",
          "black",
        },
        handlers = {}
      }
    },

    {
      "folke/neodev.nvim",
      ft = "lua",
    },

    {
      "onsails/lspkind.nvim",
      config = function()
        local lspkind = require('lspkind')

        for _, tbl in pairs(lspkind.presets) do
          for name, icon in pairs(tbl) do
            tbl[name] = icon .. ' '
          end
        end

        lspkind.init({
          preset = "codicons",
        })
      end,
    },

    {
      "j-hui/fidget.nvim",
      opts = {
        progress = {
          suppress_on_insert = true,
          display = {
            done_ttl = 2,
            progress_icon = { pattern = "grow_horizontal", period = 0.75 },
          },
        },
        notification = {
          window = {
            border = tools.ui.cur_border,
            normal_hl = "NormalFloat",
            winblend = 0
          }
        }
      }
    }
  }
}
