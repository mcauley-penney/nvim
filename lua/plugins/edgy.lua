return {
  "folke/edgy.nvim",
  opts = {
    animate = { enabled = false },
    exit_when_last = true,
    right = {
      {
        ft = "aerial",
        pinned = true,
        open = "AerialToggle",
        size = { width = 0.17 },
      },
    },
    icons = {
      closed = " " .. tools.ui.icons.r_chev,
      open = " " .. tools.ui.icons.d_chev,
    },
  },
}
