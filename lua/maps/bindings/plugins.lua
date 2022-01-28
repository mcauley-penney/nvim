local utils = require("maps.bindings.utils")
local na = {}

-- outline
utils.map("n", "<F14>", "<cmd>SymbolsOutline<cr>", utils.cmd)

-- trouble
utils.map("n", "<leader>q", "<cmd>TroubleToggle quickfix<cr>", na)

-- substitute.nvim
utils.map("n", "r", "<cmd>lua require('substitute').operator()<cr>", utils.nore)
utils.map("n", "rr", "<cmd>lua require('substitute').line()<cr>", utils.nore)
utils.map("n", "R", "<cmd>lua require('substitute').eol()<cr>", utils.nore)
utils.map("x", "r", "<cmd>lua require('substitute').visual()<cr>", utils.nore)

-- vim-doge
vim.g.doge_mapping = "<leader>id"

-- vim-printer
vim.g.vim_printer_print_below_keybinding = "<leader>ip"
vim.g.vim_printer_print_above_keybinding = "<leader>iP"

-- vim-swap
utils.map("n", "<left>", "g<", na)
utils.map("n", "<right>", "g>", na)

-- vim-wordmotion
vim.g.wordmotion_mappings = { e = "k", ge = "gk" }
