for _, module in pairs({ "globals", "statusline" }) do
	require("jmp.options." .. module)
end


local o = vim.opt

--- Check if a cmd is executable
--- @param exe_str string
--- @return boolean
local function is_exe(exe_str)
	return vim.fn.executable(exe_str) > 0
end

-- Top level function called in options.init to get fold text.
-- @return str: fold text to be displayed
_G.get_fold_text = function()
	local ui = require("jmp.ui")
	local no_hl_icons = ui.no_hl_icons

	local tab_len = vim.api.nvim_buf_get_option(0, "softtabstop")
	local num_spaces = math.floor(vim.v.foldlevel * tab_len)
	local indent = string.rep(" ", num_spaces)

	return string.format(
		"%s%s (%s lines)",
		indent,
		no_hl_icons["fold"],
		vim.v.foldend - vim.v.foldstart + 1
	)
end

o.breakindent = true
o.breakindentopt = "shift:2"
o.colorcolumn = "+0"
o.cindent = true
o.clipboard = "unnamedplus"
o.cmdwinheight = 30
o.confirm = true
o.diffopt:append { "linematch:60" }
o.emoji = true
o.expandtab = false
o.fileignorecase = true
o.fillchars = { eob = "⌁", fold = " " }
o.foldenable = false
o.foldlevel = 99
o.foldmethod = "indent"
o.foldtext = "v:lua.get_fold_text()"
o.gdefault = true

if is_exe("rg") then
	o.grepprg = [[rg --glob "!.git" --hidden --smart-case  --vimgrep]]
else
	o.grepprg = [[grep -nrH ]]
end

o.guicursor = {
	"n-sm-v:block",
	"c-ci-cr-i-ve:ver1",
	"o-r:hor10",
	"a:Cursor/Cursor-blinkwait0-blinkoff10-blinkon10"
}
o.helpheight = 30
o.hlsearch = true
o.inccommand = "split"
o.ignorecase = true
o.laststatus = 3
o.lazyredraw = false
o.list = true
o.listchars = {
	eol = "↴",
	lead = "·",
	nbsp = "◊",
	tab = "  ",
	trail = "·",
}
o.linebreak = true
o.modeline = false
o.modelines = 0
o.mouse = ""
o.nrformats = "alpha"
o.number = true
o.redrawtime = 150
o.relativenumber = true
o.ruler = false
o.scrolloff = 60
o.sessionoptions = "buffers,folds,skiprtp"
o.shada = "'0,:30,/30"
o.shiftround = true
o.shortmess = "acstFOW"
o.showcmd = false
o.showmode = false
o.showtabline = 1
o.sidescrolloff = 5
o.signcolumn = "yes:1"
o.smartcase = true
o.splitkeep = "screen"
o.statusline = "%!v:lua.get_statusline()"
o.swapfile = false
o.synmaxcol = 1000
o.tabline = "%=" .. vim.fn.tabpagenr()
o.termguicolors = true
o.timeout = false
o.title = true
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
o.viewoptions = { "cursor", "folds" }
o.virtualedit = "all"
o.wildignore = "*.o"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.winbar = " "
o.writebackup = false


-- turn off search highlighting when the user presses a
-- key other than those associated with search movement
vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		vim.opt.hlsearch = vim.tbl_contains({
			"<CR>",
			"n",
			"N",
			"*",
			"#",
			"?",
			"/"
		}, vim.fn.keytrans(char))
	end
end, vim.api.nvim_create_namespace "auto_hlsearch")
