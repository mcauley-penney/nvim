require("jmp.plugins.cfg.packer").bootstrap_packer()

vim.cmd("colorscheme still_light")

require("impatient")

for _, module in pairs({
    "options",
    "maps",
    "aucmd",
    "plugins",
    "ui",
    "cmd",
}) do
    require("jmp." .. module)
end
