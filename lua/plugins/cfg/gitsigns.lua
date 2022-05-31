local utils = require("utils")

local bg = utils.get_hl_grp_rgb("__termbg", "bg")
local grn = utils.get_hl_grp_rgb("__success", "fg")
local red = utils.get_hl_grp_rgb("DiagnosticError", "fg")
local ylw = utils.get_hl_grp_rgb("DiagnosticWarn", "fg")

local hl = {
    add = {
        fg = grn,
    },
    change = {
        fg = ylw,
    },
    changedelete = {
        fg = ylw,
    },
    delete = {
        fg = red,
    },
    topdelete = {
        fg = red,
    },
}

for type, hl_tbl in pairs(hl) do
    hl_tbl.bg = bg
    hl_tbl.grp = "Gitsigns" .. type

    utils.make_hl_grp_str(hl_tbl)
end

local signs_tbl = {
    add = {
        text = "+",
    },
    change = {
        text = "│",
    },
    changedelete = {
        text = "~",
    },
    delete = {
        text = "_",
    },
    topdelete = {
        text = "‾",
    },
}

for _, type in pairs(signs_tbl) do
    type.hl = hl.types
end

require("gitsigns").setup({
    signs = signs_tbl,
    signcolumn = false,
})
