return {
  "neovim/nvim-lspconfig",

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "neovim/nvim-lspconfig"
    },
    opts = {
      ui = {
        border = tools.ui.border,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = tools.ui.icons.ellipses,
          package_uninstalled = "✗",
        },
      }
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = {
      debounce = 300,
      on_attach = require("lsp.on_attach"),
    }
  },

  {
    "folke/neodev.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = "lua",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason.nvim",
    },
    config = {
      ensure_installed = {
        "clangd",
        "html",
        "jsonls",
        "lua_ls",
        "pyright",
        "tsserver"
      },
    }
  },

  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = {
      automatic_installation = true,
      ensure_installed = {
        "actionlint",
        "black",
        "fixjson",
        "pydocstyle",
        "shellcheck",
      },
      handlers = {}
    }
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
    dependencies = {
      "neovim/nvim-lspconfig",
    }
  },
}
