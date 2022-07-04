--- Check if a cmd is executable
--- @param exe_str string
--- @return boolean
local function is_exe(exe_str)
    return vim.fn.executable(exe_str) > 0
end

for _, module in pairs({ "functions", "globals", "status" }) do
    require("jmp.options." .. module)
end

local o = vim.opt

for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
    o[opt] = 4
end

o.breakindentopt = "shift:1"
o.colorcolumn = "+0"
o.cindent = true
o.clipboard = "unnamedplus"
o.confirm = true
o.emoji = true
o.fileignorecase = true
o.fillchars = { fold = " " }
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
    "n-sm-v:block-Cursor",
    "c-ci-cr-i-ve:ver20-Cursor",
    "o-r:hor20-Cursor",
}
o.hlsearch = false
o.laststatus = 3
o.list = true
o.listchars = {
    eol = "↴",
    tab = "⇥ ",
    trail = "•",
}
o.linebreak = true
o.modeline = false
o.modelines = 0
o.nrformats = "alpha"
o.number = true
o.numberwidth = 1
o.redrawtime = 150
o.relativenumber = true
o.ruler = false
o.scrolloff = 60
o.sessionoptions = "buffers,folds,skiprtp"
o.shada = "'0,:30,/30"
o.shiftround = true
o.shortmess = "acstFOW"
o.showbreak = "↳"
o.showcmd = false
o.showmode = false
o.showtabline = 1
o.sidescrolloff = 5
o.signcolumn = "yes:1"
o.statusline = "%!v:lua.get_statusline()"
o.swapfile = false
o.synmaxcol = 1000
o.tabline = "%=" .. vim.fn.tabpagenr()
o.termguicolors = true
o.timeout = false
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
o.viewoptions = { "cursor", "folds" }
o.virtualedit = "all"
o.wildignore = "*.o"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.writebackup = false
