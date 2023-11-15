--[[
         .               ...     ..      ..         ....      ..
     .x88888x.         x*8888x.:*8888: -"888:     +^""888h. ~"888h
    :8**888888X.  :>  X   48888X `8888H  8888    8X.  ?8888X  8888f
    f    `888888x./  X8x.  8888X  8888X  !888>  '888x  8888X  8888~
   '       `*88888~  X8888 X8888  88888   "*8%- '88888 8888X   "88x:
    \.    .  `?)X.   '*888!X8888> X8888  xH8>    `8888 8888X  X88x.
     `~=-^   X88> ~    `?8 `8888  X888X X888>      `*` 8888X '88888X
            X8888  ~   -^  '888"  X888  8888>     ~`...8888X  "88888
            488888      dx '88~x. !88~  8888>      x8888888X.   `%8"
    .xx.     88888X   .8888Xf.888x:!    X888X.:   '%"*8888888h.   "
   '*8888.   '88888> :""888":~"888"     `888*"    ~    888888888!`
     88888    '8888>     "~'    "~        ""           X888^"""
     `8888>    `888                                    `88f
      "8888     8%                                      88
       `"888x:-"                                        ""

   ⸬ https://github.com/mcauley-penney ⸬
]]

-- bootstrap package manager
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
  print("New Setup! Initializing …")

  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazy_path,
  })
end

vim.opt.runtimepath:prepend(lazy_path)


-- set providers
-- https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt
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

vim.g.python3_host_prog = "/usr/bin/python3"

for _, provider in ipairs({ "node", "perl", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

require("globals")
require("options")
require("maps")
require("aucmd")
require("cmd")


require('lazy').setup("plugins", {
  change_detection = { notify = false },
  checker = {
    enabled = true,
    concurrency = 20,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
  defaults = { lazy = false },
  ui = {
    border = tools.ui.border,
    icons = tools.ui.bullet,
  },
})

vim.api.nvim_set_hl(0, "LazyButton", { link = "Visual" })
vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "LazyProgressDone", { link = "LazyComment" })
vim.api.nvim_set_hl(0, "LazyProgressTodo", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "LazySpecial", { link = "Comment" })

vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = "Open [p]ackage [m]anager" })


require("ui")
require("lsp")
