local o, opt = vim.o, vim.opt

o.breakindent = true
o.breakindentopt = "shift:2"
o.cindent = true
o.clipboard = "unnamedplus"
o.cmdwinheight = 30
o.colorcolumn = "+0"
o.confirm = true
o.cursorline = true
opt.cursorlineopt = { "number" }
opt.diffopt = {
  "filler",
  "indent-heuristic",
  "linematch:60",
  "vertical"
}
o.emoji = true
o.expandtab = true
o.fileignorecase = true
opt.fillchars = {
  fold = ' ',
  foldclose = tools.ui.icons.r_chev,
  foldopen = tools.ui.icons.d_chev,
  foldsep = ' ',
  msgsep = '─',
}
o.foldcolumn = '1'
o.foldlevel = 99
o.foldmethod = "indent"
o.gdefault = true

if vim.fn.executable("rg") > 0 then
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
  --  eol = "¬",
  nbsp = "◆",
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
o.scrolloff = 30
o.sessionoptions = "buffers,skiprtp"
o.shiftround = true
o.shortmess = "acstFOSW"
o.showcmd = false
o.showmode = false
o.showtabline = 1
o.sidescrolloff = 5
o.signcolumn = "yes:1"
o.smartcase = true
o.splitkeep = "screen"
o.swapfile = false
o.synmaxcol = 1000
o.termguicolors = true
o.timeout = false
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
opt.viewoptions = {
  "cursor",
  "folds",
}
o.virtualedit = "all"
o.wildignore = "*.o"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.winbar = " "
o.writebackup = false
