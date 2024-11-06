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
}
