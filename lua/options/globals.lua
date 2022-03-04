-- clipboard
-- see https://github.com/neovim/neovim/blob/master/runtime/autoload/provider/clipboard.vim
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

-- filetype
vim.g.python_recommended_style = 0
vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1

--[[
    providers
    https://github.com/neovim/neovim/blob/master/runtime/doc/provider.txt
]]
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0 -- disables Python2 support
vim.g.loaded_ruby_provider = 0

vim.g.python3_host_prog = "/usr/bin/python3"
