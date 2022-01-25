local srcs = require("options.status.external_srcs")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
STATUS_PARTS = {
    ab_path = " %F",
    diag = nil,
    file_name = " %t",
    icon = nil,
    indent = "%=",
    lines = "%l/%L ",
    mod = "%m",
    ro = "%r",
}

EXCLUDED = {
    "OUTLINE",
    "Trouble",
    "[startuptime]",
}

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
_G.get_active_status = function()
    -- Get fmt strs from dict and concatenate them into one string.
    -- @param key_list: table of keys to use to access fmt strings
    -- @param dict: associative array to get fmt strings from
    -- @return string of concatenated fmt strings and data that will create the
    -- statusline when evaluated
    local function _concat_status(key_list, dict)
        local str_table = {}

        for _, val in ipairs(key_list) do
            table.insert(str_table, dict[val])
        end

        return table.concat(str_table, " ")
    end

    local function _is_acceptable_buf(exclude_dict)
        local buf = vim.fn.expand("%:t")

        for _, file_name in ipairs(exclude_dict) do
            if buf == file_name then
                return false
            end
        end

        return true
    end

    local status_tbl = { "file_name" }

    -- if the current buffer name is not in the table of buffer names that we do not
    -- want a statusline for, proceed
    if _is_acceptable_buf(EXCLUDED) then
        local status_bg = require("utils").get_hl_by_name("StatusLine", "bg")

        -- init tables of keys used to access statusline fmt strs
        status_tbl = { "icon", "ab_path", "mod", "ro", "indent", "diag", "lines" }

        -- store diagnostics and icons, always accessed
        STATUS_PARTS["diag"] = srcs.get_diagnostics(status_bg)
        STATUS_PARTS["icon"] = srcs.get_icon(status_bg)
    end

    -- concatenate desired status components into str
    return _concat_status(status_tbl, STATUS_PARTS)
end
