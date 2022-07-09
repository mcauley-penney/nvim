local styles = require("jmp.style")

local termbg = { attribute = "bg", highlight = "Normal" }
local termdarken = { attribute = "bg", highlight = "__termdarken" }
local diag_red = { attribute = "fg", highlight = "DiagnosticError" }
local diag_yellow = { attribute = "fg", highlight = "DiagnosticWarn" }

local opt_tbl = {
  enforce_regular_tabs = true,
  highlights = {
    -- background = {
    --   gui = "italic",
    --   guibg = termbg,
    -- },
    -- buffer = {
    --   gui = "italic",
    -- },
    buffer_selected = {
      gui = "none",
    },
    buffer_visible = {
      guibg = termdarken,
    },
    fill = {
      guibg = termbg,
    },
    duplicate_selected = {
      guifg = diag_yellow,
    },
    duplicate = {
      guifg = diag_yellow,
      guibg = termbg,
    },
    indicator_selected = {
      guifg = termbg,
      guibg = termbg,
    },
    modified = {
      guifg = diag_red,
      guibg = termbg,
    },
    modified_selected = {
      guifg = diag_red,
    },
    modified_visible = {
      guifg = diag_red,
      guibg = termbg,
    },
    -- separator = {
    --   guifg = termbg,
    --   guibg = termbg,
    -- },
    -- separator_selected = {
    --   guifg = termbg,
    -- },
    -- separator_visible = {
    --   guifg = termbg,
    --   guibg = termbg,
    -- },
  },

  options = {
    always_show_bufferline = false,
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
