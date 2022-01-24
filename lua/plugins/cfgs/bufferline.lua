local get_hl = require("utils").get_hl_by_name

require("bufferline").setup({
    highlights = {
        modified = {
            guifg = get_hl("Error"),
        },
        modified_selected = {
            guifg = get_hl("Error"),
        },

        separator = {
            guifg = get_hl("__termbg", "bg"),
            guibg = get_hl("__termbg", "bg"),
        },
    },

    options = {
        always_show_bufferline = false,
        indicator_icon = "",
        show_tab_indicators = false,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
    },
})
