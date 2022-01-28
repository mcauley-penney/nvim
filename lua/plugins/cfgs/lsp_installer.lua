-- get our onAttach fn inside a table
local onAttach = { on_attach = require("plugins.cfgs.lsp_config").onAttach }

-- define servers and the settings that we want to use with them
local servers = {
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

-- choose server options.
-- if a server has a table above, we want to use those settings with our onAttach. If
-- not, we want to just use onAttach
-- @param server: server being attached to buffer
local get_server_opts = function(server)
    if servers[server.name] ~= nil then
        return vim.tbl_deep_extend("keep", servers[server.name], onAttach)
    else
        return onAttach
    end
end

-- init LspInstaller
require("nvim-lsp-installer").on_server_ready(function(server)
    local options = get_server_opts(server)

    server:setup(options)
end)
