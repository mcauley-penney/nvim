--[[
    https://neovim.io/doc/user/options.html

    nvim defaults:  https://neovim.io/doc/user/vim_diff.html
    opt syntax:     https://github.com/neovim/neovim/pull/13479#event-4813249467
]]

local utils = require("utils")

for _, module in pairs({ "functions", "globals", "status" }) do
    require("options." .. module)
end

local o = vim.opt

o.breakindentopt = "shift:1"
o.colorcolumn = "+0"
o.cindent = true
o.clipboard = "unnamedplus"
o.confirm = true
o.emoji = false
o.expandtab = true
o.fileignorecase = true
o.fillchars = { fold = " " }
o.foldenable = false
o.foldlevel = 99
o.foldmethod = "indent"
o.foldtext = "v:lua.get_fold_text()"
o.gdefault = true

if utils.is_exe("rg") then
    o.grepprg = [[rg --glob "!.git" --hidden --smart-case  --vimgrep]]
else
    o.grepprg = [[grep -nrH ]]
end

o.guicursor = {
    "n-sm-v:block-Cursor",
    "c-ci-cr-i-ve:ver20-Cursor",
    "o-r:hor20-Cursor",
}
o.hlsearch = false
o.laststatus = 3
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
o.sessionoptions = "buffers,folds,skiprtp"
o.shada = "'0,:30,/30"
o.shiftround = true
o.shiftwidth = 4
o.shortmess = "acstFOW"
o.showbreak = "↳"
o.showcmd = false
o.showmode = false
o.showtabline = 1
o.signcolumn = "yes:1"
o.softtabstop = 4
o.statusline = "%!v:lua.get_statusline()"
o.swapfile = false
o.synmaxcol = 1000
o.tabline = "%=" .. vim.fn.tabpagenr()
o.termguicolors = true
o.timeout = false
-- o.timeoutlen = 500
o.undodir = vim.fn.stdpath("data") .. "/undo/"
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
o.viewoptions = { "cursor", "folds" }
o.virtualedit = "all"
o.wildignore = "*.o"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.writebackup = false
