for _, module in pairs({ "statusline", "statuscol" }) do
	require("jmp.options." .. module)
end

local o, opt = vim.o, vim.opt

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
opt.diffopt = {
	"filler",
	"indent-heuristic",
	"linematch:60",
	"vertical"
}
o.emoji = true
o.expandtab = false
o.fileignorecase = true
opt.fillchars = { fold = " ", foldclose = '►', foldopen = '▼', foldsep = " " }
o.foldcolumn = '1'
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

opt.guicursor = {
	"n-sm-v:block",
	"c-ci-cr-i-ve:ver10",
	"o-r:hor10",
	"a:Cursor/Cursor"
}
o.helpheight = 70
o.hlsearch = true
o.inccommand = "split"
o.ignorecase = true
o.laststatus = 3
o.list = true
opt.listchars = {
	eol = "¬",
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
o.pumblend = 10
o.redrawtime = 150
o.relativenumber = true
o.ruler = false
o.scrolloff = 60
o.sessionoptions = "buffers,folds,skiprtp"
o.shada = "'0,:30,/30"
o.shiftround = true
o.shortmess = "acstFOSW"
o.showcmd = false
o.showmode = false
o.showtabline = 1
o.sidescrolloff = 5
o.signcolumn = "yes:1"
o.smartcase = true
o.splitkeep = "screen"
o.statuscolumn = "%!v:lua.get_statuscol()"
o.statusline = "%!v:lua.get_statusline()"
o.swapfile = false
o.synmaxcol = 1000
-- o.tabline = "%=" .. vim.fn.tabpagenr()
o.termguicolors = true
o.timeout = false
o.title = true
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
opt.viewoptions = { "cursor", "folds" }
o.virtualedit = "all"
o.wildignore = "*.o"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.winbar = " "
o.winblend = 10
o.writebackup = false
