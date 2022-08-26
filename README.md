##### Todo
* feats
    * vim compatability:
        * dockerize so we can run anywhere?
* to fix
    * mason
        * uninstall mypy and flake8 via pip and get via mason

    * fzf.lua
        * include quickfix colors

    * markdown fenced code highlights

    * clangd cross file rename
        * requires compile_commands.json or .txt, I think
            * must test


##### News
* CursorHold bug *(legendary status)*:
    * original issue: https://github.com/neovim/neovim/issues/12587
    * Shougo's pr: https://github.com/neovim/neovim/pull/16929

* merging impatient.nvim: https://github.com/neovim/neovim/pull/15436

* msg: https://github.com/neovim/neovim/pull/16396

* anticonceal: https://github.com/neovim/neovim/pull/9496

* splitscroll stabilization:
    * https://github.com/neovim/neovim/pull/19243
    * https://github.com/vim/vim/pull/10682#issuecomment-1193060554=

* keep an eye on evolving diagnostics situation. MJ didn't like null-ls
    * https://github.com/nvim-lua/wishlist/issues/9#issuecomment*1025087308
    * https://www.reddit.com/r/neovim/comments/u36pvq/how_to_disable_individual_capabilities_of_lsp/
    * https://www.reddit.com/r/neovim/comments/sol86s/question_about_diagnostics_with_lsp/
    * https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3

* Elastic tabstops: https://github.com/neovim/neovim/issues/1419


##### Common doc sources
* autocommands: [[docs](https://neovim.io/doc/user/autocmd.html), [TJ Devries video guide](https://www.youtube.com/watch?v=ekMIIAqTZ34)]
* vim.fn: [docs (usr_41)](https://neovim.io/doc/user/usr_41.html#function*list)
* API: [docs](https://neovim.io/doc/user/api.html)
* vim lua functionality: [docs](https://neovim.io/doc/user/lua.html)
* options: [[defaults](https://neovim.io/doc/user/vim_diff.html), [docs](https://neovim.io/doc/user/options.html)]
* diagnostics: [docs](https://neovim.io/doc/user/diagnostic.html)
* highlights: [docs](https://neovim.io/doc/user/syntax.html#highlight-groups)
