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
  desc = "Set root dir and initialize version control branch"
})

aucmd({ "BufEnter", "BufWinEnter" }, {
  group = grp,
  callback = function()
    vim.api.nvim_set_option_value("formatoptions", "2cjnpqrt", {})

    vim.opt.formatlistpat:append([[\|^\s*\w\+[\]:.)}\t ]\s\+]]) -- Lettered lists
    vim.opt.formatlistpat:append([[\|^>\s]])                    -- Markdown blockquotes

    -- Dynamically append commentstring-based pattern
    local commentstring = vim.bo.commentstring:match("^(.*)%%s$")
    if commentstring then
      vim.opt.formatlistpat:append([[\|^\s*]] .. commentstring .. [[\s*]])
    end

    local ft = get_opt("filetype", {})
    require("aucmd.functions").set_indent(ft)
    require("aucmd.functions").set_textwidth(ft)

    -- set foldmethod
    -- we also set via LSP. This is a fallback for when there is no language server
    -- https://www.reddit.com/r/neovim/comments/w4ckuf/config_if_treesitter_is_active/
    local ok, parser = pcall(vim.treesitter.get_parser)
    if ok and parser then
      vim.o.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.o.foldmethod = "indent"
    end
  end,
  desc = "Set options for formatting"
})

aucmd("BufNewFile", {
  group = grp,
  command = "silent! 0r "
      .. vim.fn.stdpath("config") .. "/templates/skeleton.%:e",
  desc = "If one exists, use a template when opening a new file"
})

aucmd("BufWinEnter", {
  group = grp,
  command = "silent! loadview",
  desc = "Restore view settings"
})

-- See https://vi.stackexchange.com/a/12710
aucmd("BufWinEnter", {
  group = grp,
  command = [[call matchadd("String", '\v[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')]],
  desc = "Highlight email addresses"
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

vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorHoldI" }, {
  group = grp,
  callback = function()
    local win_h = vim.api.nvim_win_get_height(0)                 -- height of window
    local off = math.min(vim.o.scrolloff, math.floor(win_h / 2)) -- scroll offset
    local dist = vim.fn.line "$" - vim.fn.line "."               -- distance from current line to last line
    local rem = vim.fn.line "w$" - vim.fn.line "w0" + 1          -- num visible lines in current window

    if dist < off and win_h - rem + dist < off then
      local view = vim.fn.winsaveview()
      view.topline = view.topline + off - (win_h - rem + dist)
      vim.fn.winrestview(view)
    end
  end,
  desc = "When at eob, bring the current line towards center screen"
})

vim.api.nvim_create_autocmd('VimResized', {
  group = grp,
  command = [[tabdo wincmd =]]
})

--  vim.api.nvim_create_autocmd('TextYankPost', {
--    group = grp,
--    callback = function()
--      vim.highlight.on_yank({ higroup = "Visual", timeout = 190 })
--    end,
--    pattern = '*',
--  })

----------------------------------------
-- Upon leaving a buffer
----------------------------------------
grp = augrp("Leaving", { clear = true })

aucmd("BufWinLeave", {
  group = grp,
  command = "silent! mkview",
  desc = "Create view settings"
})
