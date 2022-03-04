local lsp = {
    servers = {
        clangd = {
            cmd = {
                "clangd",
                "--all-scopes-completion",
                "--clang-tidy",
                "--completion-style=detailed",
                "--cross-file-rename",
                "--fallback-style=Microsoft",
                "--header-insertion=never",
                "--header-insertion-decorators",
                "-j=6",
                "--limit-results=10",
                "--pch-storage=memory",
                "--suggest-missing-includes",
            },
        },
        sumneko_lua = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
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
                    format = { enable = true },
                },
            },
        },
    },

    langs = { "c", "lua", "python", "sh" },

    signs = {
        Error = { sym = "" },
        Warn = { sym = "" },
        Hint = { sym = "" },
        Info = { sym = "" },
    },
}

-- define signs and highlights for diag types
for diag_type, cfg in pairs(lsp.signs) do
    local hl = table.concat({ "DiagnosticSign", diag_type }, "")

    vim.fn.sign_define(hl, { text = cfg.sym, texthl = hl })
end

-- configure diagnostics
vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
        -- prefix = "",
        source = "if_many",
    },
})

-- override handlers
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers["signature_help"],
    {
        border = "none",
        close_events = { "InsertLeavePre" },
        focus = false,
        silent = true,
    }
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "single" }
)

return lsp
