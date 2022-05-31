local utils = require("utils")
local hl_mtbl = {}

local statusbg = utils.get_hl_grp_rgb("StatusLine", "bg")

for type, _ in pairs(require("lsp").signs) do
    hl_mtbl[type] = utils.make_hl_grp_str({
        grp = "Status" .. type,
        fg = utils.get_hl_grp_rgb("Diagnostic" .. type, "fg"),
        bg = statusbg,
    })
end

hl_mtbl["Success"] = utils.make_hl_grp_str({
    grp = "StatusSuccess",
    fg = utils.get_hl_grp_rgb("__success", "fg"),
    bg = statusbg,
})

return hl_mtbl
