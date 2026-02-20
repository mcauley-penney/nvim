return {
  {
    "brianhuster/live-preview.nvim",
    ft = "markdown",
    config = function()
      require("livepreview.config").set({ dynamic_root = true })
    end,
  },
}
