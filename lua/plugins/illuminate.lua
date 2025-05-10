return {
  {
    "echasnovski/mini.cursorword",
    version = false,
    config = function()
      require("mini.cursorword").setup({ delay = 350 })

      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
      vim.api.nvim_set_hl(0, "MiniCursorword", { link = "Underlined" })
    end,
  },

  {
    "mcauley-penney/match-visual.nvim",
    opts = {
      min_length = 3,
    },
    config = function(_, opts)
      require("match-visual").setup(opts)
      vim.api.nvim_set_hl(0, "VisualMatch", { link = "Search" })
    end,
  },

  {
    "rareitems/hl_match_area.nvim",
    opts = {
      highlight_in_insert_mode = false,
    },
  },
}
