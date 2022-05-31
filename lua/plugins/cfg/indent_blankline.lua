require("indent_blankline").setup({
    char = "├",
    buftype_exclude = { "terminal" },
    filetype_exclude = { "packer" },
    max_indent_increase = 1,
    show_first_indent_level = false,
    show_trailing_blankline_indent = false,
})
