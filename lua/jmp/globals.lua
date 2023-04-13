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
local branch_cache = {}

--------------------------------------------------
-- functions
--------------------------------------------------

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
vim.g.get_path_root = function(path)
	if path == "" then return end

	local root = vim.b.path_root
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
	vim.b.path_root = root

	return root
end

vim.g.get_git_branch = function(root)
	if root == nil then return end

	local branch = branch_cache[root]
	if branch ~= nil then return branch end

	local cmd = table.concat({"git", "-C", root, "branch --show-current"}, " ")
	branch = vim.fn.system(cmd)
	if branch == nil then return nil end

	branch = branch:gsub("\n", "")
	branch_cache[root] = branch

	return branch
end
