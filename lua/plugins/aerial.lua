return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      close_on_select = false,
      max_width = 45,
      min_width = 35,
      close_automatic_events = { "switch_buffer", "unfocus", "unsupported" },
    }
  },
  config = function(_, opts)
    require('aerial').setup(opts)

    vim.keymap.set("n", "<F18>", "<cmd>AerialToggle<cr>", { silent = true })

    vim.api.nvim_set_hl(0, "AerialLine", { link = "CurSearch" })
  end
}
