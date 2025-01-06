return {
  --  'stevearc/conform.nvim',
  --  --  event = 'BufReadPre',
  --  opts = {
  --    formatters_by_ft = {
  --      bib = { 'bibtex-tidy' }
  --    },
  --    format_on_save = function(buf)
  --      if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then return end
  --      return { timeout_ms = 300, lsp_fallback = true }
  --    end,
  --  },
}
