local link_char = "  "

return {
  {
    "brianhuster/live-preview.nvim",
    ft = "markdown",
    config = function()
      require("livepreview.config").set({ dynamic_root = true })
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
        icons = { "■", "□", "●", "○", "◆", "◊" },
        highlight = "@markup.list.markdown",
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
        image = "  ",
        email = "󰇮  ",
        hyperlink = link_char,
        custom = {
          web = { pattern = "^http", icon = link_char },
          sweb = { pattern = "^https", icon = link_char },
          linkedin = { pattern = "linkedin%.com", icon = "  " },
          youtube = { pattern = "youtube%.com", icon = "  " },
          github = { pattern = "github%.com", icon = "  " },
          stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌  " },
          discord = { pattern = "discord%.com", icon = "  " },
          reddit = { pattern = "reddit%.com", icon = "  " },
          acm = { pattern = "dl.acm%.org", icon = "  " },
          arxiv = { pattern = "arxiv%.org", icon = "  " },
        },
      },
    },
  },
}
