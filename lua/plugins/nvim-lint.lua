return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPre',
  init = function()
    vim.api.nvim_create_autocmd({ 'TextChanged' }, {
      callback = function() require('lint').try_lint() end,
    })
  end,
  config = function()
    require('lint').linters_by_ft = {
      javascript = { 'eslint' },
      markdown = { 'markdownlint' },
    }
  end,
}
