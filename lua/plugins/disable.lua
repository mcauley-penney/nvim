-- default plugins: https://neovim.io/doc/user/index.html#standard-plugin-list

-- disable default plugins
local to_disable = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logiPat",
    "man",
    "matchit",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "remote_plugins",
    "rrhelper",
    "spellfile_plugin",
    "spec",
    "tar",
    "tarPlugin",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plug in ipairs(to_disable) do
    vim.g["loaded_" .. plug] = 1
end
