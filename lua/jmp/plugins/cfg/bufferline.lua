local styles = require("jmp.style")

local termbg = { attribute = "bg", highlight = "Normal" }
local termdarken = { attribute = "bg", highlight = "__termdarken" }
local diag_red = { attribute = "fg", highlight = "DiagnosticError" }
local diag_yellow = { attribute = "fg", highlight = "DiagnosticWarn" }

local opt_tbl = {
  highlights = {
    buffer_visible = {
      bg = termdarken,
    },
    fill = {
      bg = termbg,
    },
    duplicate = {
      fg = diag_yellow,
    },
    duplicate_selected = {
      fg = diag_yellow,
    },
    duplicate_visible = {
      fg = diag_yellow,
      bg = termdarken,
    },
    indicator_selected = {
      fg = termbg,
      bg = termbg,
    },
    modified = {
      fg = diag_red,
    },
    modified_selected = {
      fg = diag_red,
    },
    modified_visible = {
      fg = diag_red,
      bg = termdarken,
    },
  },

  options = {
    always_show_bufferline = false,
    enforce_regular_tabs = true,
    modified_icon = styles.icons["mod"],
    separator_style = "thin",
    show_buffer_close_icons = false,
    show_buffer_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    sort_by = "insert_after_current",
  },
}

require("bufferline").setup(opt_tbl)

local map = vim.api.nvim_set_keymap
local cmd = { noremap = true, silent = true }

map("n", "<C-Pageup>", "<cmd>BufferLineCyclePrev<CR>", cmd)
map("n", "<C-S-Pageup>", "<cmd>BufferLineMovePrev<CR>", cmd)
map("n", "<C-Pagedown>", "<cmd>BufferLineCycleNext<CR>", cmd)
map("n", "<C-S-Pagedown>", "<cmd>BufferLineMoveNext<CR>", cmd)
