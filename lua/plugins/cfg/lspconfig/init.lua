local func = require("plugins.cfg.lspconfig.functions")
require("nvim-lsp-installer").setup({})

local M = {
    on_attach = function(client, bufnr)
        -- local function set_opts(bufnr, str)
        --     return { buffer = bufnr, desc = str }
        -- end

        local lsp = vim.lsp.buf
        local map = vim.keymap.set

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "editing",
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end

        local opts = { buffer = bufnr }

        map("n", "E", lsp.hover, opts)
        map("i", "<C-e>", lsp.signature_help, opts)

        map("n", "<leader>D", lsp.type_definition, opts)
        map("n", "<leader>ca", lsp.code_action, opts)
        map("n", "<leader>gD", lsp.declaration, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "<leader>gr", lsp.references, opts)
        map("n", "<leader>rn", func.rename, {})

        map("n", "<up>", function()
            vim.diagnostic.goto_prev({ float = false })
        end, {})

        map("n", "<down>", function()
            vim.diagnostic.goto_next({ float = false })
        end, {})

        map("n", "<leader>vd", function()
            vim.diagnostic.open_float({
                height = 15,
                width = 50,
            })
        end, {})
    end,
}

for name, cfg in pairs(require("lsp").servers) do
    cfg.on_attach = M.on_attach
    require("lspconfig")[name].setup(cfg)
end

return M
