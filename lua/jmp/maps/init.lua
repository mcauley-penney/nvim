--[[
    mappings
        vim.keymap.set: https://github.com/neovim/neovim/pull/16594
]]

local func = require("jmp.maps.functions")
local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true, silent = true }

vim.g.mapleader = "m"

--------------------------------------------------
-- Plugins
--------------------------------------------------

-- Gitsigns
map("n", "<leader>gt", "<cmd>Gitsigns toggle_signs<cr>", silent)
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", silent)
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", silent)

-- hop.nvim
map("n", "/", "<cmd>HopChar1<cr>", silent)

-- neogen
map("n", "<leader>id", "<cmd>lua require('neogen').generate()<CR>", {})

-- nvim-docs-view
map("n", "<F13>", "<cmd>DocsViewToggle<cr>", silent)

-- Trouble
map("n", "<leader>q", "<cmd>TroubleToggle quickfix<cr>", {})

-- substitute.nvim
map("n", "r", require("substitute").operator, {})
map("n", "rr", require("substitute").line, {})
map("n", "R", require("substitute").eol, {})
map("x", "r", require("substitute").visual, {})

-- symbols-outline
map("n", "<F1>", "<cmd>SymbolsOutline<cr>", silent)

-- venn.nvim
map("n", "<S-down>", "<C-v>j:VBox<CR>", {})
map("n", "<S-up>", "<C-v>k:VBox<CR>", {})
map("n", "<S-left>", "<C-v>h:VBox<CR>", {})
map("n", "<S-right>", "<C-v>l:VBox<CR>", {})
-- draw a box by pressing "f" with visual selection
map("v", "b", ":VBox<CR>", {})

-- vim-mundo
map("n", "<leader>u", "<cmd>MundoToggle<cr>", {})

-- vim-swap
map("n", "<left>", "<Plug>(swap-prev)", {})
map("n", "<right>", "<Plug>(swap-next)", {})

-- vim-wordmotion
vim.g.wordmotion_mappings = { e = "k", ge = "gk" }

--------------------------------------------------
-- Base
--------------------------------------------------
map("i", "<F2>", func.send_comment, expr)

map("i", "<F2>", func.send_comment, expr)

map("i", "<F14>", "• ", {})
map("i", "!!", "!=", {})

-- assignment operator
map("i", "<F1>", "= ", {})

-- CR to enter cmd mode
for _, mode in pairs({ "n", "v" }) do
    map(mode, "<CR>", ":", {})
end

-- swap i and a
map("n", "i", "a", {})
map("n", "a", "i", {})

-- space for insert mode
map("n", "<Space>", "a", {})
map("v", "<Space>", "I", {})

-- make single char case change more accessible
map("n", "`", "~", {})
map("v", "`", "~", {})

-- tab and bs for indentation
map("n", "<tab>", ">>", {})
map("n", "<bs>", "<<", {})

-- move to first non-blank char
map("", "<home>", "^", {})
map("i", "<home>", "<esc>^a", {})

-- make '/' default to custom ripgrep command
map("n", "<C-f>", ":LOOK ", {})

-- open URLs
map("n", "<leader>o", "<cmd>!xdg-open <cWORD> > /dev/null & <CR><CR>", silent)

-- buffers --
map("n", "<C-t>", ":e ", {})
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
    map("", lhs, rhs, {})

    -- uppercase
    map("", upper_lhs, upper_rhs, {})

    -- reverse lowercase
    map("", rhs, lhs, {})

    -- reverse uppercase
    map("", upper_rhs, upper_lhs, {})
end

for _, mode in pairs({ "n", "v" }) do
    map(mode, "e", "v:count == 0 ? 'gk' : 'k'", expr)
    map(mode, "n", "v:count == 0 ? 'gj' : 'j'", expr)
end

-- split nav
map("n", "<C-n>", "<C-W><C-J>", {})
map("n", "<C-e>", "<C-W><C-K>", {})
