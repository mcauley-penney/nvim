return {
  "stevearc/aerial.nvim",
  opts = {
    close_automatic_events = {
      "unfocus",
      "switch_buffer",
    },
    guides = {
      mid_item = "  ",
      last_item = "  ",
      nested_top = "  ",
    },
    layout = {
      placement = "window",
      close_on_select = false,
      max_width = 30,
      min_width = 30,
    },
    ignore = {
      buftypes = {},
    },
    icons = tools.ui.kind_icons,
    show_guides = true,
    open_automatic = function()
      local aerial = require("aerial")
      return vim.api.nvim_win_get_width(0) > 80 and not aerial.was_closed()
    end,
  },
  config = function(_, opts)
    require("aerial").setup(opts)

    vim.keymap.set("n", "<F18>", "<cmd>AerialToggle<cr>", { silent = true })
  end,
}
