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
    pos = "cmd",
    box = {
      timeout = 4000,
    },
  },
})

-- TODO: remove when this becomes configurable
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "msgbox", "msgmore", "msgprompt", "cmdline" },
  callback = function()
    vim.api.nvim_set_option_value(
      "winhl",
      "Normal:Normal,FloatBorder:FloatBorder",
      {}
    )
  end,
})

-- turn off deprecation messages
vim.deprecate = function() end

-- include our settings
require("globals")
require("options")
require("maps")
require("aucmd")
require("filetype")

-- init plugins
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
    icons = tools.ui.bullet,
  },
})

vim.keymap.set(
  "n",
  "<leader>pm",
  "<cmd>Lazy<cr>",
  { desc = "Open [p]ackage [m]anager" }
)

-- finish settings
require("ui")
