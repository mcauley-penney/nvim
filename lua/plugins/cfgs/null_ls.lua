local null = require("null-ls")

null.setup({
    on_attach = require("plugins.cfgs.lsp_config").onAttach,
    sources = {
        -- c

        -- json
        null.builtins.formatting.fixjson,

        -- lua
        null.builtins.formatting.stylua.with({
            extra_args = {
                "--column-width",
                "80",
                "--indent-type",
                "Spaces",
                "--indent-width",
                "4",
            },
        }),

        -- python
        null.builtins.diagnostics.pylint.with({
            method = null.methods.DIAGNOSTICS_ON_SAVE,
        }),
        null.builtins.formatting.black,

        -- sh
        null.builtins.diagnostics.shellcheck,
    },
})
