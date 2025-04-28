return {
  'stevearc/conform.nvim',
  --  event = 'BufReadPre',
  opts = {
    formatters_by_ft = {
      bib = { 'bibtex-tidy' },
      markdown = { 'prettier' }
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
  vim.keymap.set('n', "<leader>f", function()
    require("conform").format()
  end, { desc = "[f]ormat with LSP" })
}
