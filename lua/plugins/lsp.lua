return {
  {
    "neovim/nvim-lspconfig",
  },

  {
    "mason-org/mason.nvim",
    opts = {
      max_concurrent_installers = 20,
      ui = {
        height = 0.8,
        icons = {
          package_installed = tools.ui.icons.bullet,
          package_pending = tools.ui.icons.ellipses,
          package_uninstalled = tools.ui.icons.open_bullet,
        },
      },
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
          progress_style = "NonText",
        },
      },
      notification = {
        window = {
          border_hl = "NonText",
          normal_hl = "NonText",
          winblend = 0,
        },
      },
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {
      text_format = function(symbol)
        local res = {}

        if symbol.references then
          local usage = symbol.references == 1 and "reference" or "references"
          table.insert(res, { "󰌹  ", "NonText" })
          table.insert(
            res,
            { ("%s %s"):format(symbol.references, usage), "NonText" }
          )
        end

        return res
      end,
    },
  },
}
