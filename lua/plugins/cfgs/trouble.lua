require("trouble").setup({
    action_keys = { toggle_fold = "<F2>" },
    fold_closed = ">", -- icon used for closed folds
    fold_open = "v", -- icon used for open folds
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
