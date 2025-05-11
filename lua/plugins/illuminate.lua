return {
  {
    "rrethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        delay = 350,
        filetypes_denylist = {
          "aerial",
          "neo-tree",
        },
        modes_denylist = { "v", "V" },
        under_cursor = false,
      })
    end,
  },

  {
    "mcauley-penney/match-visual.nvim",
  },

  {
    "rareitems/hl_match_area.nvim",
    opts = {
      highlight_in_insert_mode = false,
    },
  },
}
