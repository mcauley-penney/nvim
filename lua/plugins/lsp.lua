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
          done_icon = tools.ui.icons.ok,
          progress_icon = {
            pattern = {
              " 󰫃 ",
              " 󰫄 ",
              " 󰫅 ",
              " 󰫆 ",
              " 󰫇 ",
              " 󰫈 ",
            },
          },
          done_style = "NonText",
          group_style = "NonText",
          icon_style = "NonText",
          progress_style = "NonText",
        },
      },
      notification = {
        window = {
          border_hl = "LspCodeLens",
          normal_hl = "LspCodeLens",
          winblend = 0,
          border = "solid",
          relative = "win",
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
          table.insert(
            res,
            { ("󰌹  %s %s"):format(symbol.references, usage), "LspCodeLens" }
          )
        end

        return res
      end,
    },
  },
}
