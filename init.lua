--[[
             ______________
            /             /|
           /             / |
          /____________ /  |
         | ___________ |   |
         ||           ||   |
         ||           ||   |
         ||           ||   |
         ||___________||   |
         |   _______   |  /
        /|  (_______)  | /
       ( |_____________|/
        \
    .=======================.
    | ::::::::::::::::  ::: |
    | ::::::::::::::[]  ::: |
    |   -----------     ::: |
    `-----------------------'

⸬ https://github.com/mcauley-penney ⸬

]]

-- bootstrap package manager
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  print("New Setup! Initializing …")

  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
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
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- extui
require("vim._extui").enable({
  enable = true,
  msg = {
    target = "cmd",
  },
})

-- include our settings
require("globals")
require("options")
require("maps")
require("aucmd")
require("filetype")

require("lazy").setup("plugins", {
  install = { missing = false },
  change_detection = { enabled = true, notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  defaults = { lazy = false },
  ui = {
    backdrop = 100,
    border = "solid",
    title = "Lazy",
    pills = true,
    icons = {
      cmd = tools.ui.kind_icons.Terminal,
      config = "󰒓 ",
      debug = "● ",
      event = " ",
      favorite = "  ",
      ft = tools.ui.kind_icons.File,
      init = "󰒓 ",
      import = " 󰋺  ",
      keys = " 󰥻  ",
      lazy = "󰒲  ",
      loaded = tools.ui.icons.bullet,
      not_loaded = tools.ui.icons.open_bullet,
      plugin = tools.ui.kind_icons.Module,
      runtime = "  ",
      require = "󰢱  ",
      source = " ",
      start = " ",
      task = tools.ui.icons.ok,
      list = { "■", "□", "●", "○", "◆", "◊" },
    },
  },
})

vim.cmd("packadd nvim.undotree")

vim.keymap.set(
  "n",
  "<leader>pm",
  "<cmd>Lazy<cr>",
  { desc = "Open [p]ackage [m]anager" }
)

-- finish settings
require("ui")
