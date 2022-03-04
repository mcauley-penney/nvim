local get_hi = require("utils").get_hl_grp_rgb

local mark_text = { "-", "=" }
local priority_index = 1

local marks_tbl = {
    Error = {},
    Warn = {},
    Info = {},
    Hint = {},
}

for type, cfg in pairs(marks_tbl) do
    cfg.color = get_hi("Diagnostic" .. type, "fg")
    cfg.priority = priority_index
    cfg.text = mark_text

    priority_index = priority_index + 1
end

require("scrollbar").setup({
    handle = {
        color = get_hi("StatusLine", "bg"),
    },
    marks = marks_tbl,
})
