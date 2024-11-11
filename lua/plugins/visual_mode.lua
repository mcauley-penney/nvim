return {
  {
    "mcauley-penney/visual-whitespace.nvim",
    branch = "async",
    config = function()
      local ws_bg = tools.get_hl_hex({ name = "Visual" })["bg"]
      local ws_fg = tools.get_hl_hex({ name = "Comment" })["fg"]

      require("visual-whitespace").setup({
        highlight = { bg = ws_bg, fg = ws_fg },
        nl_char = '¬',
        excluded = {
          filetypes = { "aerial" },
          buftypes = { "help" }
        }
      })

      vim.keymap.set('n', "<leader>vw", require("visual-whitespace").toggle, {})
    end
  },

  {
    "mcauley-penney/match-visual.nvim",
    opts = {
      min_length = 3
    },
  },
}
