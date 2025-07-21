return {
  "folke/edgy.nvim",
  opts = {
    animate = { enabled = false },
    exit_when_last = true,
    right = {
      {
        title = "Outline",
        ft = "aerial",
        open = "AerialToggle",
        size = {
          width = 0.13,
        },
      },
    },
    icons = {
      closed = " " .. tools.ui.icons.r_chev,
      open = " " .. tools.ui.icons.d_chev,
    },
  },
}
