return {
  --  {
  --    "folke/trouble.nvim",
  --    config = function()
  --      require("trouble").setup()

  --      vim.api.nvim_create_autocmd("DiagnosticChanged", {
  --        command = "Trouble diagnostics open"
  --      })
  --    end
  --  },

  {
    "LunarVim/bigfile.nvim",
    opts = {
      features = {
        "illuminate",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
      },
    }
  },

  {
    "mcauley-penney/autolist.nvim",
    ft = {
      "markdown",
      "plaintex",
      "tex",
      "text",
    },
    config = function()
      require("autolist").setup()

      vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")

      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "m<CR>", "o<cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "m<SPACE>", "O<cmd>AutolistNewBulletBefore<cr>")
      vim.keymap.set("n", "<C-Space>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      vim.keymap.set("n", "<leader>lr", "<cmd>AutolistRecalculate<cr>")

      -- cycle list types with dot-repeat
      vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
      vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

      -- functions to recalculate list on edit
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = "markdown",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      render_modes = true,
      code = {
        width = "block",
        position = 'left',
        highlight = "markdownCodeBlock",
        language_pad = 2,
        left_pad = 2,
        right_pad = 2
      },
      heading = {
        border = false,
        position = "inline",
        backgrounds = {
          'makdownH1',
        },
        icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ', },
      },
      quote = {
        highlight = "NonText",
        repeat_linebreak = true,
      },
      win_options = {
        conceallevel = { rendered = 3, },
      },
    },
  },

  --  {
  --    'tzachar/highlight-undo.nvim',
  --    keys = { { "u" }, { "<C-r>" } },
  --    opts = {
  --      keymaps = {
  --        paste = { disabled = true },
  --        Paste = { disabled = true },
  --      },
  --    },
  --    config = function(_, opts)
  --      require('highlight-undo').setup({ opts })

  --      vim.api.nvim_set_hl(0, "HighlightUndo", { link = "DiffChange" })
  --      vim.api.nvim_set_hl(0, "HighlightRedo", { link = "DiffAdd" })
  --    end
  --  }
}
