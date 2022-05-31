-- init

for _, plug in pairs({
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logiPat",
    "man",
    "matchit",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "remote_plugins",
    "rrhelper",
    "spellfile_plugin",
    "spec",
    "tar",
    "tarPlugin",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}) do
    vim.g["loaded_" .. plug] = 1
end

vim.cmd("colorscheme still_light")

for _, module in pairs({
    "impatient",
    "options",
    "maps",
    "aucmd",
    "plugins",
    "cmd",
    "lsp",
    "ui",
}) do
    require(module)
end

--[[

    todo:
        • dockerize

    news:
        • CursorHold bug (legendary status):
            • original issue: https://github.com/neovim/neovim/issues/12587
            • Shougo's pr: https://github.com/neovim/neovim/pull/16929

        • merging filetype.nvim:
            •  https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
            •  https://github.com/nathom/filetype.nvim/issues/36

        • merging impatient.nvim: https://github.com/neovim/neovim/pull/15436

        • msg:
            •  https://github.com/neovim/neovim/pull/16396

        • anticonceal: https://github.com/neovim/neovim/pull/9496

        • keep an eye on evolving diagnostics situation. The authors don't
          like null-ls
            • https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025087308
            • https://www.reddit.com/r/neovim/comments/u36pvq/how_to_disable_individual_capabilities_of_lsp/
            • https://www.reddit.com/r/neovim/comments/sol86s/question_about_diagnostics_with_lsp/
            • https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3
]]
