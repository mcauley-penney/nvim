local grn = "Success"
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

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>gt", gs.toggle_signs)
    map({ "n", "v" }, "<leader>gs", gs.stage_hunk)
    map("n", "<leader>gp", gs.preview_hunk)
    map("n", "<leader>gu", gs.undo_stage_hunk)
  end
})
