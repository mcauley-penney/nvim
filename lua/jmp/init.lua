--
--
-- 	   *
-- 	  ***
-- 	   *
-- 	                           ****
-- 	 ***   *** **** ****      * ***  *
-- 	  ***   *** **** ***  *  *   ****
-- 	   **    **  **** ****  **    **
-- 	   *     **   **   **   **    **   ⎡
-- 	  *      **   **   **   **    **   ⎢ McAuley Penney
-- 	 ***     **   **   **   **    **   ⎢ https://github.com/mcauley-penney
-- 	  ***    **   **   **   **    **   ⎣
-- 	   ***   **   **   **   *******
-- 	    ***  ***  ***  ***  ******
-- 	     **   ***  ***  *** **
-- 	     **                 **
-- 	     *                  **
-- 	    *                    **
--
--


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

vim.loader.enable()

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


require('lazy').setup("jmp.plugins", {
	ui = { border = "single" },
	defaults = { lazy = false },
	change_detection = { notify = false },
	checker = {
		enabled = true,
		concurrency = 30,
		notify = false,
		frequency = 3600, -- check for updates every hour
	},
	performance = {
		rtp = {
			paths = { data_path .. '/site' },
		},
	},
})

require("jmp.lsp")
