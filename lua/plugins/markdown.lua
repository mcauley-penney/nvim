return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      local g = vim.g
      g.mkdp_auto_start = 0
      g.mkdp_auto_close = 1
      g.mkdp_page_title = "${name}.md"
      g.mkdp_preview_options = {
        disable_sync_scroll = 0,
        disable_filename = 1,
      }
      g.mkdp_theme = "dark"
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = "markdown",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      render_modes = true,
      code = {
        sign = false,
        width = "block",
        position = 'left',
        highlight = "@markup.raw.block",
        language_pad = 0,
        left_pad = 1,
        right_pad = 3,
        inline_pad = 1,
        highlight_inline = "@markup.raw.markdown_inline",
      },
      heading = {
        enabled = false,
        width = 'block',
        position = "inline",
        backgrounds = {
          '@markup.heading.1.markdown',
        },
      },
      quote = {
        highlight = "NonText",
        repeat_linebreak = true,
      },
      bullet = {
        icons = { '●', '○', '◆', '◊' },
      },
      pipe_table = {
        --  preset = "round",
        style = "normal",
        cell = "raw",
      },
      html = { comment = { conceal = false } },
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
  }
}
