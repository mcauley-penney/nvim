return {
  "stevearc/aerial.nvim",
  opts = {
    backends = { "treesitter", "lsp" },
    close_automatic_events = {
      "unfocus",
      "switch_buffer",
      "unsupported",
    },
    guides = {
      mid_item = "  ├",
      last_item = "  └",
      nested_top = "  │",
    },
    layout = {
      close_on_select = false,
      max_width = 35,
      min_width = 35,
    },
    ignore = {
      buftypes = {}
    },
    show_guides = true,
    open_automatic = function(bufnr)
      local aerial = require("aerial")
      return vim.api.nvim_win_get_width(0) > 120 and
          aerial.num_symbols(bufnr) > 0 and
          not aerial.was_closed()
    end,
  },
  config = function(_, opts)
    require('aerial').setup(opts)

    vim.keymap.set("n", "<F18>", "<cmd>AerialToggle<cr>", { silent = true })

    vim.api.nvim_set_hl(0, "AerialLine", { link = "PmenuSel" })
  end
}
