return {
  {
    "rrethy/vim-illuminate",
    config = function()
      require('illuminate').configure({
        delay = 150,
        filetypes_denylist = {
          'aerial',
          'neo-tree',
        },
        modes_denylist = { 'v', 'V' },
        under_cursor = false,
      })
    end,
  },

  {
    "rareitems/hl_match_area.nvim",
    opts = {
      highlight_in_insert_mode = false,
    },
    init = function()
      vim.api.nvim_set_hl(0, "MatchArea", { link = "Visual" })
    end
  },
}
