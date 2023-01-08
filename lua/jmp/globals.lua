--------------------------------------------------
-- builtin settings
--------------------------------------------------

-- clipboard
-- see https://github.com/neovim/neovim/blob/master/runtime/autoload/provider/clipboard.vim
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

-- filetype
vim.g.python3_host_prog = "/usr/bin/python3"

-- turn off a bunch of default plugins
for _, plug in pairs({
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logiPat",
	"matchit",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"remote_plugins",
	"rrhelper",
	"spellfile_plugin",
	"spec",
	"tar",
	"tarPlugin",
	"tutor_mode_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}) do
	vim.g["loaded_" .. plug] = 1
end

-- providers
-- https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt
for _, provider in ipairs({ "node", "perl", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

--------------------------------------------------
-- custom resources
--------------------------------------------------

-- defines what filetypes should not be treated like source code
vim.g.nonprog_mode = {
	["markdown"] = true,
	["org"] = true,
	["orgagenda"] = true,
	["text"] = true,
}

-- provides a place to cache the root
-- directory for current editing session
vim.g.root_cache = {}
-- vim.g.branch_cache = {}

--------------------------------------------------
-- functions
--------------------------------------------------

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
vim.g.get_path_root = function(path)
	local root = vim.g.root_cache[path]
	if root ~= nil then return root end

	local root_items = {
		".git"
	}

	root = vim.fs.find(root_items, {
		path = path,
		upward = true,
		type = "directory"
	})[1]

	if root == nil then return nil end

	root = vim.fs.dirname(root)
	vim.g.root_cache[path] = root

	return root
end

-- vim.g.get_git_branch = function(root)
-- 	local branch = vim.g.branch_cache[root]
-- 	if branch ~= nil then return branch end
--
-- 	branch = vim.fn.system("git branch --show-current") or nil
-- 	if branch == nil then return nil end
--
-- 	branch = branch:gsub("\n", "")
-- 	vim.g.branch_cache[root] = branch
--
-- 	return branch
-- end
