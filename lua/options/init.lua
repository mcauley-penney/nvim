--[[
    https://neovim.io/doc/user/options.html

    nvim defaults:  https://neovim.io/doc/user/vim_diff.html
    opt syntax:     https://github.com/neovim/neovim/pull/13479#event-4813249467
]]

for _, module in pairs({ "functions", "globals", "status" }) do
    require("options." .. module)
end

-- alias syntax
local o = vim.opt

o.breakindent = true
o.breakindentopt = "shift:1"
o.colorcolumn = "+0"
o.cindent = true
o.clipboard = "unnamedplus"
o.confirm = true
o.emoji = false
o.expandtab = true
o.fileignorecase = true
o.fillchars = {
    fold = " ",
}
o.foldenable = false
o.foldlevel = 99
o.foldmethod = "indent"
o.foldtext = "v:lua.get_fold_text()"
o.gdefault = true
o.grepprg = [[rg --glob "!.git" --hidden --smart-case  --vimgrep]]
o.guicursor = {
    "n-sm-v:block-Cursor",
    "c-ci-cr-i-ve:ver20-Cursor",
    "o-r:hor20-Cursor",
}
o.hlsearch = false
o.laststatus = 3
o.lazyredraw = true
o.list = true
o.listchars = { eol = "⬎", trail = "•" }
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
o.undodir = vim.fn.stdpath("data") .. "/undo/"
o.undofile = true
o.updatetime = 350 -- used for swap file and cursorhold
o.viewoptions = { "cursor", "folds" }
o.virtualedit = "all"
o.wildmode = "longest:full"
o.wildoptions = "pum"
o.writebackup = false

-- TODO: put somewhere else
-- original by tLaw101:
--  https://www.reddit.com/r/neovim/comments/ua6826/3_lua_override_vimuiinput_in_40_lines/
local function wininput(opts, on_confirm, win_opts)
    -- create a "prompt" buffer that will be deleted once focus is lost
    local buf = vim.api.nvim_create_buf(false, false)
    vim.bo[buf].buftype = "prompt"
    vim.bo[buf].bufhidden = "wipe"

    local prompt = opts.prompt or ""
    local default_text = opts.default or ""

    -- defer the on_confirm callback so that it is
    -- executed after the prompt window is closed
    local deferred_callback = function(input)
        vim.defer_fn(function()
            on_confirm(input)
        end, 10)
    end

    -- set prompt and callback (CR) for prompt buffer
    vim.fn.prompt_setprompt(buf, prompt)
    vim.fn.prompt_setcallback(buf, deferred_callback)

    -- set some keymaps: CR confirm and exit, ESC in normal mode to abort
    vim.keymap.set({ "i", "n" }, "<CR>", "<CR><Esc>:close!<CR>:stopinsert<CR>", {
        silent = true,
        buffer = buf,
    })

    for _, lhs in pairs({ "<esc>", "q" }) do
        vim.keymap.set("n", lhs, "<cmd>close!<CR>", {
            silent = true,
            buffer = buf,
        })
    end

    local default_win_opts = {
        relative = "editor",
        row = vim.o.lines / 2 - 1,
        col = vim.o.columns / 2 - 25,
        width = 50,
        height = 1,
        focusable = true,
        style = "minimal",
        border = "rounded",
    }

    win_opts = vim.tbl_deep_extend("force", default_win_opts, win_opts)

    -- adjust window width so that there is always space
    -- for prompt + default text plus a little bit
    win_opts.width = #default_text + #prompt + 10 < win_opts.width
            and win_opts.width
        or #default_text + #prompt + 10

    -- open the floating window pointing to our buffer and show the prompt
    vim.api.nvim_open_win(buf, true, win_opts)
    vim.cmd("startinsert")

    -- set the default text (needs to be deferred after the prompt is drawn)
    vim.defer_fn(function()
        vim.api.nvim_buf_set_text(buf, 0, #prompt, 0, #prompt, { default_text })
        vim.cmd("stopinsert") -- vim.api.nvim_input("<ESC>")
        vim.api.nvim_win_set_cursor(0, { 1, #prompt + 1 })
    end, 5)
end

-- override vim.ui.input ( telescope rename/create, lsp rename, etc )
vim.ui.input = function(opts, on_confirm)
    -- intercept opts and on_confirm,
    -- check buffer options, filetype, etc and set window options accordingly.
    wininput(
        opts,
        on_confirm,
        { border = "none", relative = "cursor", row = 1, col = 0, width = 0 }
    )
end
