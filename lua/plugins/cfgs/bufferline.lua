local get_hi = require("utils").get_hl_grp_rgb

local bg_hi = get_hi("__termbg", "bg")
local err_hi = get_hi("Error", "fg")

local grp_hi = { guisp = bg_hi }

local opt_tbl = {
    enforce_regular_tabs = true,
    highlights = {
        buffer = {
            gui = "none",
        },
        buffer_selected = {
            gui = "none",
        },
        buffer_visible = {
            gui = "none",
        },
        modified = {
            guifg = err_hi,
        },
        modified_selected = {
            guifg = err_hi,
        },
        modified_visible = {
            guifg = err_hi,
        },
        separator = {
            guifg = bg_hi,
            guibg = bg_hi,
        },
    },

    options = {
        always_show_bufferline = false,
        groups = {
            items = {
                {
                    name = "[src]:",
                    matcher = function(buf)
                        local t = buf.filename
                        return t:match("%.c")
                            or t:match("%.cpp")
                            or t:match("%.lua")
                    end,
                },
                {
                    name = "[src2]:",
                    matcher = function(buf)
                        local t = buf.filename
                        return t:match("%.py") or t:match("%.sh")
                    end,
                },
                {
                    name = "[header]:",
                    matcher = function(buf)
                        local t = buf.filename
                        return t:match("%.h")
                    end,
                },
                {
                    name = "[make]:",
                    matcher = function(buf)
                        local t = buf.filename
                        return t:match("makefile") or t:match("Makefile")
                    end,
                },
                {
                    name = "[data]:",
                    matcher = function(buf)
                        local t = buf.filename
                        return t:match("%.json")
                            or t:match("%.md")
                            or t:match("%.txt")
                    end,
                },
                require("bufferline.groups").builtin.ungrouped,
            },
        },
        indicator_icon = "",
        modified_icon = "%m",
        separator_style = "thin",
        show_tab_indicators = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
    },
}

for _, cfg_tbl in ipairs(opt_tbl.options.groups.items) do
    cfg_tbl["highlight"] = grp_hi
end

require("bufferline").setup(opt_tbl)
