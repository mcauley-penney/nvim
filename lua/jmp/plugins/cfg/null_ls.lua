local null_ls = require("null-ls")
local builtins = null_ls.builtins

null_ls.setup({
	debounce = 300,
	on_attach = require("jmp.lsp.on_attach"),
	sources = {
		-- json
		builtins.formatting.fixjson,

		-- python
		builtins.diagnostics.pydocstyle,
		builtins.formatting.black.with({
			extra_args = { "--line-length", "119" },
		}),

		-- sh
		builtins.diagnostics.shellcheck,

		-- GitHub actions/yaml
		builtins.diagnostics.actionlint,
	},
})
