return {
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
        -- sign = true breaks something somewhere
        sign = false,
        width = "full",
        position = 'left',
        highlight = "@markup.raw.block",
        language_pad = 0,
        left_pad = 2,
        right_pad = 3,
        inline_pad = 1,
        highlight_inline = "@markup.raw.markdown_inline",
      },
      heading = {
        width = 'block',
        position = "inline",
        backgrounds = {
          '@markup.heading.1.markdown',
        },
        icons = { '፠ 1 ', '፠ 2 ', '፠ 3 ', '፠ 4 ', '፠ 5 ', '፠ 6 ', },
      },
      quote = {
        highlight = "NonText",
        repeat_linebreak = true,
      },
      bullet = {
        icons = { '●', '○', '◆', '◊' },
      },
      link = {
        --  enabled = false,
        image = '󰥶  ',
        email = '󰀓  ',
        hyperlink = '  ',
        custom = {
          web = { pattern = '^http', icon = '  ' },
          sweb = { pattern = '^https', icon = '  ' },
          youtube = { pattern = 'youtube%.com', icon = '󰗃  ' },
          github = { pattern = 'github%.com', icon = '󰊤  ' },
          stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌  ' },
          discord = { pattern = 'discord%.com', icon = '󰙯  ' },
          reddit = { pattern = 'reddit%.com', icon = '󰑍  ' },
        },
      },
    },
  },
}
