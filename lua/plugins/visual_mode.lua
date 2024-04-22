return {
  {
    "mcauley-penney/visual-whitespace.nvim",
    config = function()
      local ws_bg = tools.get_hl_hex({ name = "Visual" })["bg"]
      local ws_fg = tools.get_hl_hex({ name = "Comment" })["fg"]

      require("visual-whitespace").setup({
        highlight = { bg = ws_bg, fg = ws_fg },
        use_listchars = true,
        nl_char = '¬'
      })
    end
  },

  {
    "aaron-p1/match-visual.nvim",
    opts = {
      min_length = 3
    },
    init = function()
      vim.api.nvim_set_hl(0, "VisualMatch", { link = "MatchParen" })
    end
  },
}
