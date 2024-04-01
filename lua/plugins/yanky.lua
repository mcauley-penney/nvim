return {
  "gbprod/yanky.nvim",
  opts = {
    ring = {
      history_length = 0,
      storage = "memory",
      sync_with_numbered_registers = false,
    },
    system_clipboard = {
      sync_with_ring = false,
    },
    highlight = {
      on_put = true,
      on_yank = false,
      timer = 200,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  init = function()
    vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
    vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
    vim.keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
    vim.keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
  end,
}
