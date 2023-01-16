-- vim.keymap.set: https://github.com/neovim/neovim/pull/16594
-- Unused keys: https://vim.fandom.com/wiki/Unused_keys

local func = require("jmp.maps.functions")
local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true, silent = true }

vim.g.mapleader = "m"

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


--------------------------------------------------
-- Base
--------------------------------------------------
map("n", "<F1>", "za", {})

map("i", "<F6>", func.send_comment, expr)
map("i", "<F7>", "=", {})
map("i", "<F1>", "- ", {})
map("i", "<F2>", "+", {})

map("i", "!!", "!=", {})

-- CR to enter cmd mode
for _, mode in pairs({ "n", "v" }) do
	map(mode, "<CR>", ":", {})
end

-- space for insert mode
map("n", "<Space>", "a", {})
map("v", "<Space>", "I", {})

-- make single char case change more accessible
map("n", "`", "~", {})
map("v", "`", "~", {})

-- tab and bs for indentation
map("n", "<tab>", ">>", {})
map("n", "<bs>", "<<", {})

map("", "<home>", "^", {}) -- move to first non-blank char
map("i", "<home>", "<C-o>^", {}) -- move in front of first non-blank char

-- open URLs
-- https://www.reddit.com/r/neovim/comments/i72eo7/open_link_with_gx_asynchronously/
map("n", "gx", "<cmd>call jobstart(['xdg-open', expand('<cfile>')], {'detach': v:true})<CR>", silent)

-- buffers
map("n", "<leader>q", ":bd<CR>", silent)
