local func = require("maps.functions")
local utils = require("maps.bindings.utils")

local na = {}

-- comments, ◻ ◼
utils.fmap("i", "<F2>", func.send_comment, utils.expr)

-- ◻ ◼ ↑
utils.map("i", "<F14>", "• ", na)
utils.map("i", "!!", "!=", utils.nore)

-- equation
utils.map("i", "<F1>", "= ", na)

-- fold
utils.map("n", "<F2>", "za", na)

-- CR to enter cmd mode
utils.map("n", "<CR>", ":", utils.nore)
utils.map("v", "<CR>", ":", utils.nore)

-- swap i and a
utils.map("n", "i", "a", utils.nore)
utils.map("n", "a", "i", utils.nore)

-- space for insert mode
utils.map("n", "<Space>", "a", utils.nore)
utils.map("v", "<Space>", "I", utils.nore)

-- make case change more accessible
utils.map("n", "`", "~s", na)
utils.map("v", "`", "~", na)

-- tab and bs for indentation
utils.map("n", "<tab>", ">>", na)
utils.map("n", "<bs>", "<<", na)

-- move to first non-blank char
utils.map("", "<home>", "^", na)
utils.map("i", "<home>", "<esc>^a", na)

-- make '/' default to custom ripgrep command
utils.map("n", "\\", ":LOOK ", na)

-- open URLs
utils.map("n", "<leader>o", "<cmd>!xdg-open <cWORD> &<CR><CR>", utils.cmd)

-- qf
utils.map("n", "<leader>q", "<cmd>copen<cr>", na)

-- buffers --
utils.map("n", "<C-t>", ":e ", na)
utils.map("n", "<C-Pageup>", "<cmd>BufferLineCyclePrev<CR>", utils.cmd)
utils.map("n", "<C-S-Pageup>", "<cmd>BufferLineMovePrev<CR>", utils.cmd)
utils.map("n", "<C-Pagedown>", "<cmd>BufferLineCycleNext<CR>", utils.cmd)
utils.map("n", "<C-S-Pagedown>", "<cmd>BufferLineMoveNext<CR>", utils.cmd)
utils.map("n", "<C-w>", "<cmd>bd<CR>", utils.cmd)
