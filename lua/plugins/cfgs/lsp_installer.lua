require("nvim-lsp-installer").on_server_ready(function(server)
    -- get our onAttach fn inside a table
    local onAttach = { on_attach = require("plugins.cfgs.lsp_config").onAttach }
    local options = nil
    local servers = require("lsp").servers

    -- choose server options.
    -- if a server has a table above, we want to use those settings with our
    -- onAttach. If not, we want to just use onAttach.
    -- @param server: server being attached to buffer
    if servers[server.name] ~= nil then
        options = vim.tbl_deep_extend("keep", servers[server.name], onAttach)
    else
        options = onAttach
    end

    server:setup(options)
end)
