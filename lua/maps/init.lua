-- vim.keymap.set: https://github.com/neovim/neovim/pull/16594
-- Unused keys: https://vim.fandom.com/wiki/Unused_keys

local func = require("maps.functions")
local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true, silent = true }

vim.g.mapleader = "m"

local function swap_map(lhs, rhs, mode)
  map(mode or "", lhs, rhs, {})
  map(mode or "", rhs, lhs, {})
end

--------------------------------------------------
-- Colemak
--------------------------------------------------
local colemak_maps = {
  { "n", "j" }, -- down
  { "e", "k" }, -- up
  { "s", "h" }, -- left
  { "t", "l" }, -- right
}
local mvmnt_prefix = "<C-w><C-"

for _, pairs in ipairs(colemak_maps) do
  local lhs = pairs[1]
  local rhs = pairs[2]

  local mvmnt_lhs = table.concat({ mvmnt_prefix, lhs, ">" })
  local mvmnt_rhs = table.concat({ mvmnt_prefix, rhs, ">" })

  -- lowercase
  swap_map(lhs, rhs)

  -- uppercase
  swap_map(string.upper(lhs), string.upper(rhs))

  -- window movement
  swap_map(mvmnt_lhs, mvmnt_rhs)
end

for _, mode in pairs({ "n", "v" }) do
  map(mode, "e", "v:count == 0 ? 'gk' : 'k'", expr)
  map(mode, "n", "v:count == 0 ? 'gj' : 'j'", expr)
end


--------------------------------------------------
-- Base
--------------------------------------------------
map("n", "<F1>", "za", {})

map("i", "<F6>", func.send_comment, expr)
map("i", "<F1>", "- ", {})

-- CR to enter cmd mode
for _, mode in pairs({ "n", "v" }) do
  map(mode, "<CR>", ":", {})
end

-- space for insert mode
map("n", "<Space>", "a", { remap = true })
map("v", "<Space>", "I", {})

-- make single char case change more accessible
swap_map("`", "~", { 'n', 'v' })

-- tab and bs for indentation
map("n", "<tab>", ">>", {})
map("n", "<bs>", "<<", {})

map("", "<home>", "^", {})       -- move to first non-blank char
map("i", "<home>", "<C-o>^", {}) -- move in front of first non-blank char

-- tabs and buffers
map("n", "<leader>bq", ":bd<CR>", silent)
map("n", "<leader>tq", ":tabclose<CR>", silent)
map("n", "<C-Pageup>", ":bp<CR>", silent)
map("n", "<C-Pagedown>", ":bn<CR>", silent)

-- search in visual selection
map("v", "/", "<Esc>/\\%V")

-- Prepend and append new lines
map({ "n", "i" }, "<S-cr>", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
map({ "n", "i" }, "<C-cr>", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>")

map("n", "<leader>s", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]])
