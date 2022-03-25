local get_hi = require("utils").get_hl_grp_rgb

local mark_text = { "-", "=" }
local priority = 1

local marks_tbl = {
    Error = {},
    Warn = {},
    Info = {},
    Hint = {},
}

for type, cfg in pairs(marks_tbl) do
    cfg.color = get_hi("Diagnostic" .. type, "fg")
    cfg.priority = priority
    cfg.text = mark_text

    priority = priority + 1
end

require("scrollbar").setup({
    handle = {
        color = get_hi("StatusLine", "bg"),
    },
    marks = marks_tbl,
})
