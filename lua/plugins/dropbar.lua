return {
  "Bekaboo/dropbar.nvim",
  opts = {
    bar = {
      update_debounce = 100,
      sources = function(buf, _)
        local sources = require('dropbar.sources')
        local utils = require('dropbar.utils')

        if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
        if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
        return {
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
      end
    },
    icons = {
      ui = { bar = { separator = ' ' .. tools.ui.icons.r_chev .. ' ' } },
    }
  },
}
