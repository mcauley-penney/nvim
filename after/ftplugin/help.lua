vim.opt_local.list = false
vim.opt_local.colorcolumn = ""
vim.opt_local.concealcursor = "nc"

-- https://www.reddit.com/r/neovim/comments/10383z1/open_help_in_buffer_instead_of_split/
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function(event)
    if vim.bo[event.buf].filetype == 'help' then
      vim.cmd.only()
      vim.bo[event.buf].buflisted = true
    end
  end,
  desc = "Open help pages in a listed buffer in the current window."
})
