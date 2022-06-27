local lsp_ui = require("jmp.style")
local utils = require("jmp.ui.utils")
local hl_dict = {}

for type, hex_str in pairs(lsp_ui.palette) do
    hl_dict[type] = utils.make_hl_grp({
        grp = "Status" .. type,
        fg = hex_str,
        bg = lsp_ui.bg_hi,
    })
end

return hl_dict
