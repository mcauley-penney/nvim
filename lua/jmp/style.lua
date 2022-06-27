local get_hi = require("jmp.ui.utils").get_hl_grp_rgb

local make_invisible_border = function()
    local border = {}

    while #border < 8 do
        table.insert(border, { " ", "FloatBorder" })
    end

    return border
end

local make_lsp_palette = function()
    local palette = {}

    for _, sign_type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
        palette[sign_type] = get_hi("Diagnostic" .. sign_type, "fg")
    end

    palette["Fail"] = get_hi("Comment", "fg")
    palette["Success"] = get_hi("__success", "fg")

    return palette
end

return {
    bg_hi = get_hi("StatusLine", "bg"),
    border = make_invisible_border(),
    palette = make_lsp_palette(),
    signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = "",
    },
}
