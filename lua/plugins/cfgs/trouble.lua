require("trouble").setup({
    action_keys = { toggle_fold = "<F2>" },
    height = 10,
    icons = true,
    indent_lines = false,
    mode = "quickfix",
    position = "bottom",
    signs = {
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info",
    },
})
