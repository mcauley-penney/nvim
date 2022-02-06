--[[
    https://neovim.io/doc/user/options.html

    nvim defaults:  https://neovim.io/doc/user/vim_diff.html
    opt syntax:     https://github.com/neovim/neovim/pull/13479#event-4813249467
]]

require("options.functions")
require("options.providers")
require("options.status")

-- alias syntax
local o = vim.opt

o.breakindent = true
o.breakindentopt = "shift:-1"
o.colorcolumn = "+0"
o.cindent = true
o.clipboard = "unnamedplus"
o.confirm = true
o.emoji = false
o.expandtab = true
o.fillchars = { eob = " ", fold = " " }
o.foldenable = false
o.foldlevel = 99
o.foldmethod = "indent"
o.foldtext = "v:lua.get_fold_text()"
o.gdefault = true
o.grepprg = [[ rg --ignore-case --glob "!.git" --trim --vimgrep ]]
o.guicursor = "n-v-sm:block,c-ci-cr-i-ve:ver30,r-o:hor20"
o.hlsearch = false
o.lazyredraw = true
o.list = true
o.listchars = { eol = "↴", trail = "•" }
o.linebreak = true
o.modeline = false
o.modelines = 0
o.nrformats = "alpha"
o.numberwidth = 1
o.redrawtime = 150
o.ruler = false
o.scrolloff = 60
o.sessionoptions = "buffers"
o.shada = "'0,:30,/30"
o.shiftround = true
o.shiftwidth = 4
o.shortmess = "acstFOW"
o.showbreak = "↳"
o.showcmd = false
o.showmode = false
o.signcolumn = "yes:1"
o.softtabstop = 4
o.statusline = "%!v:lua.get_statusline()"
o.swapfile = false
o.synmaxcol = 1000
o.termguicolors = true
o.timeout = false
o.undodir = vim.fn.expand(vim.fn.stdpath("data")) .. "/undo/"
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
o.viewoptions = "cursor,folds"
o.virtualedit = "all"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.writebackup = false
