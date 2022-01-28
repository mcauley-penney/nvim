local signs = {
    Error = { sym = "" },
    Warn = { sym = "" },
    Hint = { sym = "" },
    Info = { sym = "" },
}

-- define signs and highlights for diag types
for diag_type, cfg in pairs(signs) do
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

return signs
