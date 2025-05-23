return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 500,
    icons = {
      separator = "→",
      mappings = false,
    },
    layout = { align = 'center' },
    triggers = {
      { "<leader>", mode = { "n", "v" } },
    },
    plugins = {
      spelling = {
        enabled = false
      },
    },
    preset = "classic",
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)

    vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
  end,
}
