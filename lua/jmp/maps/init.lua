--[[
    mappings
        vim.keymap.set: https://github.com/neovim/neovim/pull/16594
]]

local func = require("jmp.maps.functions")
local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true, silent = true }
local na = {}
local nore = { noremap = true }

vim.g.mapleader = "m"

--------------------------------------------------
-- Plugins
--------------------------------------------------
map("n", "<F1>", "<cmd>DocsViewToggle<cr>", silent)

map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<cr>", silent)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", silent)
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", silent)

-- hop.nvim
map("n", "/", "<cmd>HopChar1<cr>", silent)

-- neogen
map("n", "<leader>id", "<cmd>lua require('neogen').generate()<CR>", {})

-- vim-mundo
map("n", "<leader>u", "<cmd>MundoToggle<cr>", nore)

-- venn.nvim
map("n", "<S-down>", "<C-v>j:VBox<CR>", {})
map("n", "<S-up>", "<C-v>k:VBox<CR>", {})
map("n", "<S-left>", "<C-v>h:VBox<CR>", {})
map("n", "<S-right>", "<C-v>l:VBox<CR>", {})
-- draw a box by pressing "f" with visual selection
map("v", "b", ":VBox<CR>", nore)

-- vim-wordmotion
vim.g.wordmotion_mappings = { e = "k", ge = "gk" }

--------------------------------------------------
-- Base
--------------------------------------------------

map("i", "<F2>", func.send_comment, expr)

map("i", "<F2>", func.send_comment, expr)

map("i", "<F14>", "• ", na)
map("i", "!!", "!=", nore)

-- equation
map("i", "<F1>", "= ", na)

-- fold
map("n", "<F2>", "za", na)

-- CR to enter cmd mode
for _, mode in pairs({ "n", "v" }) do
    map(mode, "<CR>", ":", nore)
end

-- swap i and a
map("n", "i", "a", nore)
map("n", "a", "i", nore)

-- space for insert mode
map("n", "<Space>", "a", nore)
map("v", "<Space>", "I", nore)

-- make single char case change more accessible
map("n", "`", "~", na)
map("v", "`", "~", na)

-- tab and bs for indentation
map("n", "<tab>", ">>", na)
map("n", "<bs>", "<<", na)

-- move to first non-blank char
map("", "<home>", "^", na)
map("i", "<home>", "<esc>^a", na)

-- make '/' default to custom ripgrep command
map("n", "<C-f>", ":LOOK ", na)

-- open URLs
map("n", "<leader>o", "<cmd>!xdg-open <cWORD> > /dev/null & <CR><CR>", silent)

-- qf
map("n", "<leader>q", "<cmd>copen<cr>", na)

-- buffers --
map("n", "<C-t>", ":e ", na)
map("n", "<C-w>", "<cmd>bd<CR>", silent)

--------------------------------------------------
-- Colemak
--------------------------------------------------
local colemak_maps = {
    { "n", "j" }, -- down
    { "e", "k" }, -- up
    { "s", "h" }, -- left
    { "t", "l" }, -- right
}

for _, pairs in ipairs(colemak_maps) do
    local lhs = pairs[1]
    local rhs = pairs[2]

    local upper_lhs = string.upper(lhs)
    local upper_rhs = string.upper(rhs)

    -- lowercase
    map("", lhs, rhs, nore)

    -- uppercase
    map("", upper_lhs, upper_rhs, nore)

    -- reverse lowercase
    map("", rhs, lhs, nore)

    -- reverse uppercase
    map("", upper_rhs, upper_lhs, nore)
end

for _, mode in pairs({ "n", "v" }) do
    map(mode, "e", "v:count == 0 ? 'gk' : 'k'", expr)
    map(mode, "n", "v:count == 0 ? 'gj' : 'j'", expr)
end

-- split nav
map("n", "<C-n>", "<C-W><C-J>", nore)
map("n", "<C-e>", "<C-W><C-K>", nore)
