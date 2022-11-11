local augrp = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local grp

----------------------------------------
-- Upon entering
----------------------------------------
grp = augrp("entering", { clear = true })

aucmd("BufEnter", {
	group = grp,
	callback = function()
		vim.api.nvim_buf_set_option(0, "formatoptions", "2cjnpqrt")
		local ft = vim.api.nvim_buf_get_option(0, "filetype")
		require("jmp.aucmd.functions").set_indent(ft)
		require("jmp.aucmd.functions").set_textwidth(ft)
	end,
})

aucmd({ "BufEnter", "BufNewFile", "BufRead" }, {
	group = grp,
	pattern = "*.md,*.txt",
	command = [[syn match ParaFirstWord "\%(^$\n*\|\%^\)\@<=\%(^\s*\w\+\)"]],
	desc = "Embolden the first word of a paragraph. See original at https://www.reddit.com/r/vim/comments/wg1rbl/embolden_first_word_in_each_new_paragraph/"
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

aucmd("FileType", {
	group = grp,
	pattern = "help,lspinfo,qf,startuptime",
	callback = function()
		vim.api.nvim_set_keymap("n", "q", "<cmd>close<CR>", { silent = true })
	end,
	desc = "Allow us to close various buffers with just 'q'."
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

aucmd("QuickFixCmdPost", {
	group = grp,
	callback = require("fzf-lua").quickfix,
})

aucmd("TextYankPost", {
	group = grp,
	command = [[silent! lua vim.highlight.on_yank{higroup="Yank", timeout=150}]],
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
