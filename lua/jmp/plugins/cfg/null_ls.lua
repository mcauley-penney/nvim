local null_ls = require("null-ls")
local builtins = null_ls.builtins

null_ls.setup({
  debounce = 300,
  on_attach = require("jmp.plugins.cfg.lspconfig.on_attach"),
  sources = {
    -- json
    -- builtins.formatting

    null_ls.builtins.formatting.stylua.with({
      condition = function(_utils)
        return _utils.root_has_file({ "stylua.toml", ".stylua.toml" })
      end,
    }),

    -- python
    builtins.diagnostics.flake8,
    builtins.diagnostics.mypy,
    builtins.diagnostics.pydocstyle,
    builtins.diagnostics.pylint.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    }),
    builtins.formatting.black,

    -- sh
    builtins.diagnostics.shellcheck,
  },
})
