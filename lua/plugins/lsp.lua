return {
  {
    "neovim/nvim-lspconfig",
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
    "folke/lazydev.nvim",
    dependencies = "neovim/nvim-lspconfig",
    ft = "lua",
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
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
