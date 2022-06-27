for _, mod in ipairs({ "lsp", "vim_ui" }) do
    require("jmp.ui." .. mod)
end
