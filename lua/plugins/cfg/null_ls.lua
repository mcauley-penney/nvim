local null_ls = require("null-ls")
local builtins = null_ls.builtins

null_ls.setup({
    on_attach = require("plugins.cfg.lspconfig").on_attach,
    sources = {
        -- json
        builtins.formatting.fixjson,

        -- lua
        builtins.formatting.stylua.with({
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
        builtins.formatting.black,
        builtins.diagnostics.pydocstyle,
        builtins.diagnostics.pylint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),

        -- sh
        builtins.diagnostics.shellcheck,
    },
})
