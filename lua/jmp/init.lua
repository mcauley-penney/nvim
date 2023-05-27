-- ┌───────────────────────────────────┐
-- │ McAuley Penney                    │
-- │ https://github.com/mcauley-penney │
-- └───────────────────────────────────┘

-- bootstrap package manager
local fn = vim.fn
local init_str = [[
 __________________
/\                 \
\_| New Setup!     |
  |                |
  | Initializing … |
  |   _____________|_
   \_/_______________/
]]
local data_path = fn.stdpath("data")
local install_path = data_path .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(install_path) then
	print(init_str)

	fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'--single-branch',
		'https://github.com/folke/lazy.nvim.git',
		install_path,
	})
end

vim.opt.runtimepath:prepend(install_path)


-- set providers
-- https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt
vim.g.clipboard = {
	name = "xsel",
	copy = {
		["+"] = "xsel --nodetach -i -b",
		["*"] = "xsel --nodetach -i -p",
	},
	paste = {
		["+"] = "xsel -o -b",
		["*"] = "xsel -o -p",
	},
	cache_enabled = 1,
}

vim.g.python3_host_prog = "/usr/bin/python3"

for _, provider in ipairs({ "node", "perl", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end


for _, module in ipairs({
	"globals",
	"options",
	"maps",
	"aucmd",
	"cmd",
	"filetype",
}) do
	require("jmp." .. module)
end


-- init package manager
require('lazy').setup("jmp.plugins", {
	change_detection = { notify = false },
	checker = {
		enabled = true,
		concurrency = 20,
		notify = false,
		frequency = 3600, -- check for updates every hour
	},
	defaults = { lazy = false },
	ui = {
		border = "single",
		icons = {
			list = { "•" },
		}
	},
})

vim.api.nvim_set_hl(0, "LazyButton", { link = "Visual" })
vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "LazySpecial", { link = "Comment" })

vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = "Open [p]ackage [m]anager" })


require("jmp.ui")
require("jmp.lsp")
