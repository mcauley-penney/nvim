return {
  "folke/edgy.nvim",
  opts = {
    animate = { enabled = false },
    exit_when_last = true,
    right = {
      {
        title = "Outline",
        ft = "aerial",
        pinned = true,
        open = "AerialToggle",
        size = { width = 0.15 },
      },
    },
    icons = {
      closed = " ▸",
      open = " 𝅍",
    },
  },
}
