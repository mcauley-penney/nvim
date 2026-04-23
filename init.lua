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

-- set providers
-- https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

require("vim._core.ui2").enable({
  enable = true,
  pager = {
    targets = {
      [""] = "pager",
      empty = "cmd",
      bufwrite = "pager",
      confirm = "cmd",
      epager = "pager",
      echo = "pager",
      echopager = "pager",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "pager",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "pager",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "pager",
      undo = "pager",
      verbose = "pager",
      wildlist = "cmd",
      wpager = "pager",
      typed_cmd = "cmd",
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    pager = {
      height = 0.3,
      timeout = 5000,
    },
    msg = {
      height = 0.5,
    },
  },
})

vim.cmd("packadd nvim.undotree")

-- include our settings
require("globals")
require("options")
require("maps")
require("aucmd")
require("filetype")
require("plugins")
require("ui")
