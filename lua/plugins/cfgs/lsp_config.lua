require("nvim-lsp-installer").setup({})
local lspconfig = require("lspconfig")
local lsp_opts = require("lsp")

local M = {
    onAttach = function(client)
        if client.supports_method("textDocument/formatting") then
            vim.cmd(
                "au BufWritePre <buffer> lua vim.lsp.buf.format()"
            )
        end
    end,
}

for name, cfg in pairs(lsp_opts.servers) do
    cfg.on_attach = M.onAttach
    lspconfig[name].setup(cfg)
end

return M
