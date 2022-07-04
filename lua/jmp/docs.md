### Todo
    • feats
        • dockerize so we can run anywhere

        • try out highlighted put?
            • https://www.reddit.com/r/neovim/comments/vh5p42/how_to_highlight_the_put_region_with_autocmd_like/
            • https://github.com/gbprod/yanky.nvim/blob/cb656868828f772ce807fe61fd3476dfa8cab1b7/lua/yanky/highlight.lua#L35


    • scheme
        • make yank hl more neutral
        • change hop.nvim highlights
        • add light theme and make it toggle via cmd
        • make colorscheme prettier
            • base16 is always a good plan
            • see blackmetal base16
            • https://siduck.github.io/hex-tools/


    • plugins
        • learn to work with telescope
        • try out winbar for GPS?


    • to fix
        • clangd cross file rename
            • function renaming as it is now is annoying

        • consider using cursorline

        • see https://www.reddit.com/r/neovim/comments/vgxvow/comment/id63m9x/?utm_source=share&utm_medium=web2x&context=3
            and attempt to find docs for [Cland](https://clangd.llvm.org/installation)

        • put common symbols (or all symbols?) in styles
            • eg branch, save icon




### Common doc sources
##### autocommands

1. [docs](https://neovim.io/doc/user/autocmd.html)
2. [TJ Devries video guide](https://www.youtube.com/watch?v=ekMIIAqTZ34)

##### vim.fn
1. [docs (usr_41)](https://neovim.io/doc/user/usr_41.html#function-list)

##### API
1. [docs](https://neovim.io/doc/user/api.html)

##### vim lua functionality
1. [docs](https://neovim.io/doc/user/lua.html)

##### options
1. [defaults](https://neovim.io/doc/user/vim_diff.html)
2. [docs](https://neovim.io/doc/user/options.html)


### News
    • CursorHold bug (legendary status):
        • original issue: https://github.com/neovim/neovim/issues/12587
        • Shougo's pr: https://github.com/neovim/neovim/pull/16929
    • merging filetype.nvim:
        •  https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
        •  https://github.com/nathom/filetype.nvim/issues/36
    • merging impatient.nvim: https://github.com/neovim/neovim/pull/15436
    • msg: https://github.com/neovim/neovim/pull/16396
    • anticonceal: https://github.com/neovim/neovim/pull/9496
    • keep an eye on evolving diagnostics situation. The authors don't
      like null-ls
        • https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025087308
        • https://www.reddit.com/r/neovim/comments/u36pvq/how_to_disable_individual_capabilities_of_lsp/
        • https://www.reddit.com/r/neovim/comments/sol86s/question_about_diagnostics_with_lsp/
        • https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3
