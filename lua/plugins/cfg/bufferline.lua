local utils = require("utils")

local termdark = { attribute = "bg", highlight = "__termdarken" }
local diag_red = { attribute = "fg", highlight = "DiagnosticError" }
local diag_yellow = { attribute = "fg", highlight = "DiagnosticWarn" }

local opt_tbl = {
    enforce_regular_tabs = true,
    highlights = {
        background = {
            gui = "italic",
            guibg = termdark,
        },
        buffer_selected = {
            gui = "italic",
        },
        duplicate_selected = {
            guifg = diag_yellow,
        },
        duplicate = {
            guifg = diag_yellow,
            guibg = termdark,
        },
        indicator_selected = {
            guifg = termdark,
            guibg = termdark,
        },
        modified = {
            guifg = diag_red,
            guibg = termdark,
        },
        modified_selected = {
            guifg = diag_red,
        },
        modified_visible = {
            guifg = diag_red,
            guibg = termdark,
        },
        separator = {
            guifg = "#000000",
            guibg = termdark,
        },
        separator_selected = {
            guifg = "#000000",
        },
    },

    options = {
        always_show_bufferline = false,
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_buffer_icons = true,
        show_close_icon = false,
        show_tab_indicators = false,
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
