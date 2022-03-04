-- init

vim.cmd("colorscheme still_light")

local modules = {
    "options",
    "maps",
    "aucmd",
    "plugins",
    "cmd",
    "lsp",
}

for _, module in ipairs(modules) do
    require(module)
end

--[[
    todo:
        • keep an eye on evolving diagnostics situation. The authors don't
          like null
            • https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025087308
            • https://www.reddit.com/r/neovim/comments/sol86s/question_about_diagnostics_with_lsp/
            • https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3

    news:
        • CursorHold bug (legendary):
            • original issue: https://github.com/neovim/neovim/issues/12587
            • Shougo's PR: https://github.com/neovim/neovim/pull/16929
            • try out https://github.com/antoinemadec/FixCursorHold.nvim

        • merging filetype.nvim:
            •  https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
            •  https://github.com/nathom/filetype.nvim/issues/36

        • merging impatient.nvim: https://github.com/neovim/neovim/pull/15436

        • msg:
            •  https://github.com/neovim/neovim/pull/16480
            •  https://github.com/neovim/neovim/pull/16396

        • anticonceal: https://github.com/neovim/neovim/pull/9496
]]
