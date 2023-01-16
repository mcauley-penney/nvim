local augrp = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local buf_get_opt = vim.api.nvim_buf_get_option
local grp

----------------------------------------
-- Upon entering
----------------------------------------
grp = augrp("entering", { clear = true })

aucmd("BufEnter", {
	group = grp,
	-- NOTE: this will not work with moving files during editing session.
	-- To accomplish that, if we ever need, we will have to use something like
	-- gitsigns.nvim/lua/manager.lua
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		local root = vim.g.get_path_root(path)

		vim.g.get_git_branch(root)

		if root ~= nil then
			vim.cmd(":lcd " .. root)
		end
	end,
	desc = "Set root dir and initialize version control information."
})
})

aucmd("BufNewFile", {
	group = grp,
	command = "silent! 0r "
			.. vim.fn.stdpath("config") .. "/templates/skeleton.%:e",
	desc = "If one exists, use a template when opening a new file."
})

aucmd("BufWinEnter", {
	group = grp,
	command = "silent! loadview",
})

aucmd("FileType", {
	group = grp,
	pattern = "markdown,text",
	callback = function()
		vim.cmd("set spell")
	end,
})

----------------------------------------
-- During editing
----------------------------------------
grp = augrp("editing", { clear = true })

aucmd("CmdlineLeave", {
	group = grp,
	callback = function()
		vim.fn.timer_start(3000, function()
			print(" ")
		end)
	end,
})

aucmd("TextYankPost", {
	group = grp,
	command = [[silent! lua vim.highlight.on_yank{higroup="CursorLine", timeout=150}]],
})

----------------------------------------
-- Upon leaving a buffer
----------------------------------------
grp = augrp("leaving", { clear = true })

aucmd("BufWinLeave", {
	group = grp,
	command = "silent! mkview",
})

aucmd("ExitPre", {
	group = grp,
	command = "set guicursor=a:ver90",
	desc = "Set cursor back to beam when leaving Neovim."
})
