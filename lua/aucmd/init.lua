-- aucmds
--  event types: https://neovim.io/doc/user/autocmd.html#events

local aucmds = {

    -- use a template file if one exists for that filetype. See templates dir
    "au BufNewFile * silent! 0r $HOME/.config/nvim/utils/templates/skeleton.%:e",

    -- favorite formatoptions
    --  default is 1jcroql
    --  see https://vimhelp.org/change.txt.html#fo-table
    [[
        augroup EnterBuffer
            au!
            au BufEnter * lua require( "aucmd.functions" ).set_textwidth(120)
            au BufEnter * lua require( "aucmd.functions" ).hi_long_lines()
            au BufEnter * setlocal fo-=oql"
        augroup END
    ]],

    -- remember folds
    [[
        augroup Views
            au!
            au BufWinEnter * silent! loadview
            au BufWinLeave * silent! mkview
        augroup END
    ]],

    -- ft options
    [[
        augroup Ft
            au!
            au FileType tex,txt set spell
            au FileType help,lspinfo,qf,startuptime nnoremap <buffer><silent> q <cmd>close<CR>
        augroup END
    ]],

    -- clear cmd line
    [[
        augroup CmdMsgCl
            au!
            au CmdlineLeave * :call timer_start( 1500, { -> execute( "echo ' ' ", "" )})
        augroup END
    ]],

    -- turn off numbers when entering Insert
    [[
        augroup IEnter
            au!
            au InsertEnter * set nonumber | set norelativenumber
        augroup END
    ]],

    -- highlight on yank
    [[ au TextYankPost * silent! lua vim.highlight.on_yank{ higroup="Yank", timeout=165 }]],

    -- automatically open qf after grep
    [[
        augroup Quickfix
            au!
            au QuickFixCmdPost * TroubleToggle quickfix
        augroup END
    ]],

    -- change cursor back to beam when leaving neovim
    --  see https://github.com/neovim/neovim/issues/6005
    [[
        augroup ChangeCursor
            au!
            au ExitPre * set guicursor=a:ver90
        augroup END
    ]],
}

for _, au in ipairs(aucmds) do
    vim.cmd(au)
end
