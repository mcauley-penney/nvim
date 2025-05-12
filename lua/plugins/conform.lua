return {
  "stevearc/conform.nvim",
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      bib = { "bibtex-tidy" },
      html = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = { "black" },
      tex = { "tex-fmt" },
    },
    formatters = {
      ["tex-fmt"] = {
        prepend_args = { "--nowrap", "--tabsize", "4" },
      },
    },
  },
  vim.keymap.set(
    "n",
    "<leader>f",
    function() require("conform").format() end,
    { desc = "[f]ormat with LSP" }
  ),
}
