return {
  'stevearc/conform.nvim',
  event = 'BufReadPre',
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      markdown = { 'prettier' },
    },
    format_on_save = function(buf)
      if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then return end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
}
