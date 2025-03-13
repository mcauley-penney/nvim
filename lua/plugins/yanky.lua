return {
  --  "gbprod/yanky.nvim",
  --  opts = {
  --    ring = {
  --      history_length = 0,
  --      storage = "memory",
  --      sync_with_numbered_registers = false,
  --    },
  --    system_clipboard = {
  --      sync_with_ring = false,
  --    },
  --    highlight = {
  --      on_put = false,
  --      on_yank = false,
  --      timer = 200,
  --    },
  --    preserve_cursor_position = {
  --      enabled = false,
  --    },
  --  },
  --  config = function(_, opts)
  --    require("yanky").setup(opts)

  --    vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  --    vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  --    vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  --    vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
  --  end
}
