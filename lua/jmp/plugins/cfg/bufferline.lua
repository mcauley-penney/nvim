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
        buffer_visible = {
            guibg = termdark,
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
            guifg = termdark,
            guibg = termdark,
        },
        separator_selected = {
            guifg = termdark,
        },

        separator_visible = {
            guifg = termdark,
            guibg = termdark,
        },
    },

    options = {
        always_show_bufferline = false,
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
