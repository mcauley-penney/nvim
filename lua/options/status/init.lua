local srcs = require("options.status.external_srcs")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
STATUS_PARTS = {
    ab_path = " %<%F",
    diag = nil,
    file_name = " %t",
    icon = nil,
    indent = "%=",
    lines = "%4l/%-4L ", -- give ints precision of 4, left align second val with %-
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

    -- Predicate function that checks if current buffer is one that we want status for.
    -- @param exclude_list: list of buf names to exclude from applying status to
    -- @return boolean indictating if current buf is in list of bufs to exclude
    local function _is_acceptable_buf(exclude_list)
        local buf = vim.fn.expand("%:t")

        for _, file_name in ipairs(exclude_list) do
            if buf == file_name then
                return false
            end
        end

        return true
    end

    -- Predicate fn to check if the current window is where the statusline is being
    -- drawn.
    -- Notes:
    --  should avoid autocommands to track current statusline, see
    --  https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
    --  can track via global vars, see
    --  https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
    local function _is_active_win()
        return vim.g.statusline_winid == vim.api.nvim_get_current_win()
    end

    if _is_active_win() then
        if _is_acceptable_buf(EXCLUDED) then
            local status_tbl = nil
            local status_bg = require("utils").get_hl_by_name("StatusLine", "bg")

            -- init tables of keys used to access statusline fmt strs
            status_tbl = { "icon", "ab_path", "mod", "ro", "indent", "diag", "lines" }

            -- store diagnostics and icons, always accessed
            STATUS_PARTS["diag"] = srcs.get_diagnostics(status_bg)
            STATUS_PARTS["icon"] = srcs.get_icon(status_bg)

            -- concatenate desired status components into str
            return _concat_status(status_tbl, STATUS_PARTS)
        else
            return _concat_status({ "file_name" }, STATUS_PARTS)
        end
    else
        return "%#StatusLineNC#"
    end
end
