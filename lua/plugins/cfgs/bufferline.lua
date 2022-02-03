local bg_hi = require("utils").get_hl_by_name("__termbg", "bg")
local err_hi = require("utils").get_hl_by_name("Error")

require("bufferline").setup({
    highlights = {
        modified = {
            guifg = err_hi,
        },
        modified_selected = {
            guifg = err_hi,
        },

        separator = {
            guifg = bg_hi,
            guibg = bg_hi,
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
