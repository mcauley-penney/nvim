local hi = require("utils")

local priority_index = 1

local scroll_marks = {
    Error = {},
    Warn = {},
    Info = {},
    Hint = {},
}

for type, cfg in pairs(scroll_marks) do
    cfg.priority = priority_index
    cfg.text = { "-", "=" }
    cfg.color = hi.get_hl_by_name("Diagnostic" .. type)

    priority_index = priority_index + 1
end

require("scrollbar").setup({
    handle = {
        color = hi.get_hl_by_name("StatusLine", "bg"),
    },
    marks = scroll_marks,
})
