local ui = require("jmp.ui")
local lspcfg = "jmp.lsp."
local on_attach = require(lspcfg .. "on_attach")

for _, mod in ipairs({ "handlers" }) do
	require(lspcfg .. mod)
end

local servers = {
	-- see $clangd -h, https://clangd.llvm.org/installation
	clangd = {
		cmd = {
			"clangd",
			"-j=6",
			"--all-scopes-completion",
			"--background-index", -- should include a compile_commands.json or .txt
			"--clang-tidy",
			"--completion-style=detailed",
			"--fallback-style=Microsoft",
			"--function-arg-placeholders",
			"--header-insertion-decorators",
			"--header-insertion=never",
			"--limit-results=10",
			"--pch-storage=memory",
			"--query-driver=/usr/include/*", -- TODO: idk if I need this?
			"--suggest-missing-includes",
		},
	},

	-- https://github.com/sumneko/lua-language-server/blob/f7e0e7a4245578af8cef9eb5e3ec9ce65113684e/locale/en-us/setting.lua
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				format = {
					enable = true,
					defaultConfig = {
						indent_style = "tab",
						indent_size = "2",
					}
				},
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				telemetry = { enable = false },
				workspace = {
					library = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		},
	},

	tsserver = {
		init_options = {
			preferences = { includeCompletionsForModuleExports = false }
		}
	}
}

local populate_setup = function(servers_tbl, attach_fn)
	local server_setup = function(server_name, server_cfg, attach)
		server_cfg.on_attach = attach
		require("lspconfig")[server_name].setup(server_cfg)
	end


	local setup_tbl = {
		function(server_name)
			server_setup(server_name, {}, attach_fn)
		end
	}

	for name, cfg in pairs(servers_tbl) do
		setup_tbl[name] = function()
			server_setup(name, cfg, attach_fn)
		end
	end

	return setup_tbl
end

require("mason-lspconfig").setup_handlers(populate_setup(servers, on_attach))

vim.diagnostic.config({
	float = {
		border = ui.border,
		header = "",
		severity_sort = true,
	},
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	virtual_text = {
		format = function(diag)
			local prefix = ui.no_hl_icons.diagnostic
			local msg = string.gsub(diag.message, "%s*%c+%s*", ":")
			return string.format("%s [%s] %s ", prefix, diag.source, msg)
		end,
		prefix = "",
	},
})
