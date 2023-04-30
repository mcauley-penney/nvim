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


local function bootstrap_packer()
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

	local install_path = fn.stdpath("data")
			.. "/site/pack/packer/start/packer.nvim"

	if fn.empty(fn.glob(install_path)) > 0 then
		print(init_str)

		fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})

		vim.cmd("packadd! packer.nvim")

		require("packer").startup({
			function(use)
				for _, plugin in ipairs(require("jmp.plugins")) do
					use(plugin)
				end
			end,
		})

		require("packer").sync()

		return true
	end
end

if bootstrap_packer() then
	return
end

vim.loader.enable()

vim.cmd.colorscheme("hi-dungeon")

for _, module in ipairs({
	"globals",
	"options",
	"maps",
	"aucmd",
	"plugins",
	"cmd",
	"filetype",
	"lsp",
}) do
	require("jmp." .. module)
end
