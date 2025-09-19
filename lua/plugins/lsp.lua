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
    "williamboman/mason-lspconfig.nvim",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      handlers = {
        function(name) vim.lsp.enable(name) end,
      },
    },
  },

  {
    "folke/lazydev.nvim",
    dependencies = "neovim/nvim-lspconfig",
    ft = "lua",
    opts = true,
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
          done_style = "Comment",
          group_style = "Comment",
          icon_style = "Comment",
          progress_style = "Comment",
        },
      },
      notification = {
        window = {
          border_hl = "Comment",
          normal_hl = "Comment",
          winblend = 100,
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
