-- aucmds
--  event types: https://neovim.io/doc/user/autocmd.html#events

-- use a template file if one exists for that filetype. See templates dir
vim.cmd("au BufNewFile * silent! 0r $HOME/.config/nvim/utils/templates/skeleton.%:e")

-- favorite formatoptions
--  default is 1jcroql
--  see https://vimhelp.org/change.txt.html#fo-table
vim.cmd([[
    augroup EnterBuffer
        au!
        au BufEnter * lua require( "aucmd.functions" ).hi_long_lines()
        au BufEnter * setlocal fo-=oql"
    augroup END
]])

-- remember folds
vim.cmd([[
    augroup Views
        au!
        au BufWinEnter * silent! loadview
        au BufWinLeave * silent! mkview
    augroup END
]])

-- ft options
vim.cmd([[
    augroup Ft
        au!
        au FileType c,python set textwidth=88 | inoremap <buffer> !! !=
        au FileType lua,sh set textwidth=88
        au FileType gitcommit set textwidth=50
        au FileType tex,txt set textwidth=78 | set spell
        au FileType help,lspinfo,qf,startuptime nnoremap <buffer><silent> q <cmd>close<CR>
    augroup END
]])

-- clear cmd line
vim.cmd([[
    augroup CmdMsgCl
        au!
        au CmdlineLeave * :call timer_start( 1500, { -> execute( "echo ' ' ", "" )})
    augroup END
]])

-- turn off numbers when entering Insert
vim.cmd([[
    augroup IEnter
        au!
        au InsertEnter * set nonumber | set norelativenumber
    augroup END
]])

-- highlight on yank
vim.cmd(
    [[ au TextYankPost * silent! lua vim.highlight.on_yank{ higroup="Yank", timeout=165 }]]
)

-- automatically open qf after grep
vim.cmd([[
    augroup Quickfix
        au!
        au QuickFixCmdPost * TroubleToggle quickfix
    augroup END
]])

-- change cursor back to beam when leaving neovim
--  see https://github.com/neovim/neovim/issues/6005
-- TODO: fix. Breaks closing a buffer
vim.cmd([[
    augroup ChangeCursor
        au!
        au ExitPre * set guicursor=a:ver90
    augroup END
]])
