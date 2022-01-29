local lsp_servers = {
    -- see https://manpages.debian.org/experimental/clangd-13/clangd-13.1.en.html
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
}

local diag_signs = {
    Error = { sym = "" },
    Warn = { sym = "" },
    Hint = { sym = "" },
    Info = { sym = "" },
}

-- define signs and highlights for diag types
for diag_type, cfg in pairs(diag_signs) do
    local hl = table.concat({ "DiagnosticSign", diag_type }, "")

    vim.fn.sign_define(hl, {
        text = cfg.sym,
        texthl = hl,
    })
end

-- configure
vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
        prefix = "",

        -- TODO: test
        source = "if_many",
    },
})

return {
    signs = diag_signs,
    servers = lsp_servers,
}
