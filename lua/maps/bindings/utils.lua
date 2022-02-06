vim.g.mapleader = "m"

M = {
    -- see https://github.com/neovim/neovim/pull/16594
    fmap = vim.keymap.set,
    map = vim.api.nvim_set_keymap,

    cmd = { noremap = true, silent = true },
    expr = { expr = true, silent = true },
    nore = { noremap = true },
}

return M
