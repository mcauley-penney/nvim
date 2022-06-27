local lsp_ui = require("jmp.style")

-- define signs and highlights for diag types
for diag_type, sym in pairs(lsp_ui.signs) do
    local hl = table.concat({ "Diagnostic", diag_type }, "")

    vim.fn.sign_define(hl, { text = sym, texthl = hl })
end

-- configure diagnostics
vim.diagnostic.config({
    float = {
        border = lsp_ui.border,
        header = "",
        severity_sort = true,
    },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
        format = function(diag)
            local prefix = ""

            return string.format("%s %s", prefix, diag.message)
        end,
        prefix = "",
        source = "if_many",
    },
})
