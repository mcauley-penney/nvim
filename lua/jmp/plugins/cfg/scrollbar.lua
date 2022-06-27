local lsp_ui = require("jmp.style")
local palette = lsp_ui["palette"]

local mark_text = { "-", "=" }
local priority = 1

local marks_tbl = {
    Error = {},
    Warn = {},
    Info = {},
    Hint = {},
}

for mark_type, cfg in pairs(marks_tbl) do
    cfg.color = palette[mark_type]
    cfg.priority = priority
    cfg.text = mark_text

    priority = priority + 1
end

require("scrollbar").setup({
    handle = {
        color = lsp_ui["bg_hi"],
    },
    marks = marks_tbl,
})
