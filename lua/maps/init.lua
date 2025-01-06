local func = require("maps.functions")
local map = vim.keymap.set

vim.g.mapleader = 'm'
vim.g.localmapleader = ','

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

map('n', "e", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', "n", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('v', "e", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('v', "n", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


--------------------------------------------------
-- Base
--------------------------------------------------
map("n", "<F1>", "za", {})

map("i", "<F6>", func.send_comment, { expr = true, silent = true })

map('n', "<CR>", ":", { desc = "Enter command mode" })
map('v', "<CR>", ":", { desc = "Enter command mode" })

-- space for insert mode
map("n", "<Space>", "a", { remap = true })
map("v", "<Space>", "I", {})

-- make single char case change more accessible
swap_map("`", "~", { 'n', 'v' })

-- tab and bs for indentation
map("n", "<tab>", ">>", {})
map("n", "<bs>", "<<", {})

map("", "<home>", "^", { desc = "move to first non-blank char in line" })
map("i", "<home>", "<C-o>^", { desc = "move in front of first non-blank char in line" })

-- tabs and buffers
map("n", "<leader>bq", ":bd<CR>", {})
map("n", "<leader>tq", ":tabclose<CR>", { silent = true })

-- search in visual selection
map("v", "/", "<Esc>/\\%V")

map(
  "n",
  "<leader>s",
  [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
  { desc = "open %s//gI with cword" }
)

vim.keymap.set("v", "*", "y/<C-R>0<CR>", { desc = "Search for visual selection" })
