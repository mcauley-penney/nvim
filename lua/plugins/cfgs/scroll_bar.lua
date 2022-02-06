local get_hi = require("utils").get_hi_grp_rgb

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
    cfg.color = get_hi("Diagnostic" .. type).foreground

    priority_index = priority_index + 1
end

require("scrollbar").setup({
    handle = {
        color = get_hi("StatusLine").background,
    },
    marks = scroll_marks,
})
