local M = {
    onAttach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd("au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
        end
    end,
}

return M
