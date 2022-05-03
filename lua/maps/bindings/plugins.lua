local utils = require("maps.bindings.utils")
local na = {}

-- gitsigns
utils.map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<cr>", utils.cmd)
utils.map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", utils.cmd)
utils.map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", utils.cmd)

-- hop.nvim
utils.map("n", "/", "<cmd>HopChar1<cr>", utils.cmd)

-- nvim-tree, ↑◼ ◻
utils.map("n", "<F13>", "<cmd>NvimTreeToggle<cr>", utils.cmd)

-- outline ↑◼ ◻
utils.map("n", "<F1>", "<cmd>SymbolsOutline<cr>", utils.cmd)

-- substitute.nvim
utils.map("n", "r", "<cmd>lua require('substitute').operator()<cr>", utils.nore)
utils.map("n", "rr", "<cmd>lua require('substitute').line()<cr>", utils.nore)
utils.map("n", "R", "<cmd>lua require('substitute').eol()<cr>", utils.nore)
utils.map("x", "r", "<cmd>lua require('substitute').visual()<cr>", utils.nore)

utils.map(
    "n",
    "<leader>id",
    "<cmd>lua require('neogen').generate()<CR>",
    utils.cmd
)

-- vim-mundo
utils.map("n", "<C-u>", "<cmd>MundoToggle<cr>", utils.nore)
vim.g.mundo_mappings = {
    ["<cr>"] = "preview",
    e = "mode_newer",
    n = "mode_older",
    q = "quit",
}

-- venn.nvim
utils.map("n", "<S-down>", "<C-v>j:VBox<CR>", { noremap = true })
utils.map("n", "<S-up>", "<C-v>k:VBox<CR>", { noremap = true })
utils.map("n", "<S-left>", "<C-v>h:VBox<CR>", { noremap = true })
utils.map("n", "<S-right>", "<C-v>l:VBox<CR>", { noremap = true })
-- draw a box by pressing "f" with visual selection
utils.map("v", "f", ":VBox<CR>", { noremap = true })

-- vim-swap
utils.map("n", "<left>", "g<", na)
utils.map("n", "<right>", "g>", na)

-- vim-wordmotion
vim.g.wordmotion_mappings = { e = "k", ge = "gk" }
