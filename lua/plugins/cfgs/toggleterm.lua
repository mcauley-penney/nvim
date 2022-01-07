require("toggleterm").setup({
    open_mapping = [[<c-space>]],
    direction = "float",
    float_opts = {
        border = "single",
        highlights = {
            background = "ColorColumn",
        },
        width = 120,
        winblend = 0,
    },
})
