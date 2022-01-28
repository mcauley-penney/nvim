local M = {
    onAttach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd("au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
        end

        require("lsp_signature").on_attach({
            bind = true,
            hint_prefix = "",
            fix_pos = true,
            max_height = 100,
            max_width = 250,
        })
    end,
}

return M
