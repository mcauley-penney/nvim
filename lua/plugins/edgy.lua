return {
  "folke/edgy.nvim",
  opts = {
    animate = { enabled = false },
    exit_when_last = true,
    wo = {
      winhighlight = "WinBar:FloatTitle,WinBarNC:FloatTitle,Normal:NormalFloat,NormalNC:NormalFloat,EdgyIcon:Comment,EdgyIconActive:Comment",
    },
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
