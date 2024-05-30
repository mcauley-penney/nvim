return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = {
      spelling = {
        enabled = false
      },
      presets = {
        operators = false,      -- adds help for operators like d, y, ...
        motions = false,        -- adds help for motions
        text_objects = false,   -- help for text objects triggered after entering an operator
        windows = true,         -- default bindings on <c-w>
        nav = true,             -- misc bindings to work with windows
        z = true,               -- bindings for folds, spelling and others prefixed with z
        g = true,               -- bindings for prefixed with g
      },
    },
    window = { border = tools.ui.cur_border },
    layout = { align = 'center' },

    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = '→', -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
  end,
}
