return {
  {
    "mcauley-penney/visual-whitespace.nvim",
    opts = {
      nl_char = '¬',
      excluded = {
        filetypes = { "aerial" },
        buftypes = { "help" }
      }
    }
  },

  {
    "mcauley-penney/match-visual.nvim",
    opts = {
      min_length = 3
    },
    config = function(_, opts)
      require("match-visual").setup(opts)
      vim.api.nvim_set_hl(0, "VisualMatch", { link = "Search" })
    end
  },
}
