local must_bootstrap = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data")
        .. "/site/pack/packer/start/packer.nvim"

    if fn.empty(fn.glob(install_path)) > 0 then
        print("Cloning packer ..")
        fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })

        return true
    end
end

if must_bootstrap() then
    vim.cmd("packadd! packer.nvim")

    require("packer").startup({
        function(use)
            for _, plugin in ipairs(require("jmp.plugins")) do
                use(plugin)
            end
        end,
    })
    require("packer").sync()
    return
end

for _, plug in pairs({
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
}) do
    vim.g["loaded_" .. plug] = 1
end

vim.cmd("colorscheme still_light")

require("impatient")

for _, module in pairs({
    "options",
    "maps",
    "aucmd",
    "plugins",
    "cmd",
    "ui",
}) do
    require("jmp." .. module)
end
