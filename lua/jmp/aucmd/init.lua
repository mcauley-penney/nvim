local grp

----------------------------------------
-- Upon entering a buffer
----------------------------------------
grp = vim.api.nvim_create_augroup("entering", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = grp,
  callback = function()
    vim.api.nvim_buf_set_option(0, "formatoptions", "2cjnpqr")
    require("jmp.aucmd.functions").set_indent()
    require("jmp.aucmd.functions").set_textwidth()
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  group = grp,
  command = "silent! 0r "
    .. vim.fn.stdpath("config")
    .. "/lua/jmp/utils/templates/skeleton.%:e",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = grp,
  command = "silent! loadview",
})

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "markdown,txt",
  callback = function()
    vim.api.nvim_win_set_option(0, "spell", true)
  end,
})

-- allow us to close various buffers with just 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = "help,lspinfo,qf,startuptime",
  callback = function()
    vim.api.nvim_set_keymap("n", "q", "<cmd>close<CR>", { silent = true })
  end,
})

----------------------------------------
-- During editing
----------------------------------------
grp = vim.api.nvim_create_augroup("editing", { clear = true })

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = grp,
  callback = function()
    vim.fn.timer_start(3000, function()
      print(" ")
    end)
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = grp,
  command = "TroubleToggle quickfix",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = grp,
  command = [[ silent! lua vim.highlight.on_yank{ higroup="Yank", timeout=130 }]],
})

----------------------------------------
-- Upon leaving a buffer
----------------------------------------
grp = vim.api.nvim_create_augroup("leaving", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = grp,
  command = "silent! makeview",
})

vim.api.nvim_create_autocmd("ExitPre", {
  group = grp,
  callback = function()
    vim.api.nvim_set_option("guicursor", "a:ver90")
  end,
})
