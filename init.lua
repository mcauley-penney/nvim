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
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

for _, provider in ipairs({ "node", "perl", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end


-- include our settings
require("globals")
require("options")
require("maps")
require("aucmd")
require("cmd")
require("filetype")


-- init plugins
require('lazy').setup("plugins", {
  install = { missing = false },
  change_detection = { enabled = true, notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  defaults = { lazy = false },
  ui = {
    backdrop = 100,
    icons = tools.ui.bullet,
  },
})

vim.api.nvim_set_hl(0, "LazyButton", { link = "Visual" })
vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "LazyH1" })
vim.api.nvim_set_hl(0, "LazyProgressDone", { link = "LazyComment" })
vim.api.nvim_set_hl(0, "LazyProgressTodo", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "LazyReasonCmd", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonColorscheme", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonEvent", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonFt", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonPlugin", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonRequire", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonSource", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazyReasonStart", { link = "Comment" })
vim.api.nvim_set_hl(0, "LazySpecial", { link = "Comment" })

vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = "Open [p]ackage [m]anager" })


-- setup custom LSP cfgs
local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)


-- finish settings
require("ui")
