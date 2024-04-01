local augrp = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local get_opt = vim.api.nvim_get_option_value
local grp

----------------------------------------
-- Upon entering
----------------------------------------
grp = augrp("Entering", { clear = true })

aucmd("BufEnter", {
  group = grp,
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local root = tools.get_path_root(path)

    if root ~= nil then
      vim.cmd(":lcd " .. root)

      tools.get_git_branch(root)
      tools.get_git_remote_name(root)
    end
  end,
  desc = "Set root dir and initialize version control branch."
})

aucmd({ "BufEnter", "BufWinEnter" }, {
  group = grp,
  callback = function()
    vim.api.nvim_set_option_value("formatoptions", "2cjnpqrt", {})

    local ft = get_opt("filetype", {})
    require("aucmd.functions").set_indent(ft)
    require("aucmd.functions").set_textwidth(ft)
  end,
})

aucmd("BufNewFile", {
  group = grp,
  command = "silent! 0r "
      .. vim.fn.stdpath("config") .. "/templates/skeleton.%:e",
  desc = "If one exists, use a template when opening a new file."
})

aucmd("BufWinEnter", {
  group = grp,
  command = "silent! loadview",
})

-- See https://vi.stackexchange.com/a/12710
aucmd("BufWinEnter", {
  group = grp,
  command = [[call matchadd("String", '\v[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')]],
  desc = "Highlight email addresses."
})

----------------------------------------
-- During editing
----------------------------------------
grp = augrp("Editing", { clear = true })

aucmd("CmdlineLeave", {
  group = grp,
  callback = function()
    vim.fn.timer_start(3000, function()
      print(" ")
    end)
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
  group = grp,
  callback = function()
    local win_h = vim.api.nvim_win_get_height(0)
    local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
    local dist = vim.fn.line "$" - vim.fn.line "."
    local rem = vim.fn.line "w$" - vim.fn.line "w0" + 1

    if dist < off and win_h - rem + dist < off then
      local view = vim.fn.winsaveview()
      view.topline = view.topline + off - (win_h - rem + dist)
      vim.fn.winrestview(view)
    end
  end,
})

aucmd("ShellCmdPost", {
  group = grp,
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local root = tools.get_path_root(path)

    tools.set_git_branch(root)
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = grp,
  command = [[tabdo wincmd =]]
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = grp,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 190 })
  end,
  pattern = '*',
})

----------------------------------------
-- Upon leaving a buffer
----------------------------------------
grp = augrp("Leaving", { clear = true })

aucmd("BufWinLeave", {
  group = grp,
  command = "silent! mkview",
})
