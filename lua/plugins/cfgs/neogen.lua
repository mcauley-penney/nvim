require("neogen").setup({
    enabled = true,
    languages = {
        lua = {
            template = {
                annotation_convention = "ldoc",
            },
        },
        python = {
            template = {
                annotation_convention = "reST",
            },
        },
    },
})
