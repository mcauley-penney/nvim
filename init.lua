-- init

vim.cmd("colorscheme still_light")

local modules = {
    "impatient",
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
        • High
            • add pair wrapping functionality again?
            • fix url opening map

        • Medium
            • markdown hl doesn't work
            • plugins
                • consider:
                    • vim-projectionist

            • organize lsp file
                • lots of that belongs in lsp-config?


    news:
        • winbar: https://github.com/neovim/neovim/pull/17336

        • CursorHold bug (legendary status):
            • original issue: https://github.com/neovim/neovim/issues/12587
            • Shougo's PR: https://github.com/neovim/neovim/pull/16929

        • merging filetype.nvim:
            •  https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
            •  https://github.com/nathom/filetype.nvim/issues/36

        • merging impatient.nvim: https://github.com/neovim/neovim/pull/15436

        • msg:
            •  https://github.com/neovim/neovim/pull/16480
            •  https://github.com/neovim/neovim/pull/16396

        • anticonceal: https://github.com/neovim/neovim/pull/9496

        • keep an eye on evolving diagnostics situation. The authors don't
          like null
            • https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025087308
            • https://www.reddit.com/r/neovim/comments/u36pvq/how_to_disable_individual_capabilities_of_lsp/
            • https://www.reddit.com/r/neovim/comments/sol86s/question_about_diagnostics_with_lsp/
            • https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3
]]
