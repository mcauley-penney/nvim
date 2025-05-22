return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
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
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      debounce = 200,
      render_modes = true,
      code = {
        sign = false,
        border = "thin",
        below = "🮂",
        width = "block",
        position = "left",
        language_icon = false,
        language_pad = 1,
        left_pad = 1,
        right_pad = 2,
        inline_pad = 1,
        highlight = "@markup.raw.block",
        highlight_inline = "@markup.raw.markdown_inline",
        highlight_border = "@markup.raw.block",
        highlight_language = "NonText",
      },
      heading = {
        enabled = false,
        width = "block",
        position = "inline",
        backgrounds = {
          "@markup.heading.1.markdown",
        },
      },
      quote = {
        highlight = "NonText",
        repeat_linebreak = true,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◊" },
      },
      checkbox = {
        enabled = false,
      },
      pipe_table = {
        --  preset = "round",
        style = "normal",
        cell = "raw",
      },
      html = { comment = { conceal = false } },
      link = {
        --  enabled = false,
        image = "  ",
        email = "󰇮  ",
        hyperlink = "  ",
        custom = {
          web = { pattern = "^http", icon = "  " },
          sweb = { pattern = "^https", icon = "  " },
          youtube = { pattern = "youtube%.com", icon = "  " },
          github = { pattern = "github%.com", icon = "  " },
          stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌  " },
          discord = { pattern = "discord%.com", icon = "  " },
          reddit = { pattern = "reddit%.com", icon = "  " },
          acm = { pattern = "dl.acm%.org", icon = "  " },
          arxiv = { pattern = "arxiv%.org", icon = "  " },
        },
      },
    },
  },
}
