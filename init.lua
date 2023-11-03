--
-- 	   *
-- 	  ***
-- 	   *
-- 	                           ****
-- 	 ***   *** **** ****      * ***  *
-- 	  ***   *** **** ***  *  *   ****
-- 	   **    **  **** ****  **    **
-- 	   *     **   **   **   **    **   ┌─
-- 	  *      **   **   **   **    **   │ McAuley Penney
-- 	 ***     **   **   **   **    **   │ https://github.com/mcauley-penney
-- 	  ***    **   **   **   **    **   └─
-- 	   ***   **   **   **   *******
-- 	    ***  ***  ***  ***  ******
-- 	     **   ***  ***  *** **
-- 	     **                 **
-- 	     *                  **
-- 	    *                    **
--

-- bootstrap package manager
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
	print("New Setup! Initializing …")

	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'--single-branch',
		'https://github.com/folke/lazy.nvim.git',
		lazy_path,
	})
end

vim.opt.runtimepath:prepend(lazy_path)


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

require("globals")
require("options")
require("maps")
require("aucmd")
require("cmd")


require('lazy').setup("plugins", {
	change_detection = { notify = false },
	checker = {
		enabled = true,
		concurrency = 20,
		notify = false,
		frequency = 3600, -- check for updates every hour
	},
	defaults = { lazy = false },
	ui = {
		border = tools.ui.border,
		icons = tools.ui.bullet,
	},
})

vim.api.nvim_set_hl(0, "LazyButton", { link = "Visual" })
vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "LazyProgressDone", { link = "LazyComment" })
vim.api.nvim_set_hl(0, "LazyProgressTodo", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "LazySpecial", { link = "Comment" })

vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = "Open [p]ackage [m]anager" })


require("ui")
require("lsp")
