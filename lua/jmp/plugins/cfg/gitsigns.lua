local grn = "__success"
local red = "DiagnosticError"
local ylw = "DiagnosticWarn"

local signs_tbl = {
  add = {
    hl = grn,
    text = "+",
  },
  change = {
    hl = ylw,
    text = "│",
  },
  changedelete = {
    hl = ylw,
    text = "~",
  },
  delete = {
    hl = red,
    text = "_",
  },
  topdelete = {
    hl = red,
    text = "‾",
  },
}

require("gitsigns").setup({
  signs = signs_tbl,
  signcolumn = false,
})
