local null = require("null-ls")

null.setup({
    on_attach = require("lsp.utils").onAttach,
    sources = {
        -- c
        -- json
        null.builtins.formatting.fixjson,

        -- lua
        null.builtins.formatting.stylua.with({
            extra_args = { "--column-width", "88", "--indent-type", "Spaces" },
        }),

        -- markdown

        -- python
        null.builtins.diagnostics.pylint.with({
            method = null.methods.DIAGNOSTICS_ON_SAVE,
        }),
        null.builtins.formatting.black,

        -- sh
        null.builtins.diagnostics.shellcheck,
    },
})
