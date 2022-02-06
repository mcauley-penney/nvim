local get_hi = require("utils").get_hi_grp_rgb
local srcs = require("options.status.external_srcs")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local status_parts = {
    ab_path = " %<%F",
    diag = nil,
    file_name = " %t",
    icon = nil,
    indent = "%=",
    file_info = nil,
    mod = nil,
    ro = "%r",
}

local status_order = {
    "icon",
    "ab_path",
    "mod",
    "ro",
    "indent",
    "diag",
    "file_info",
}

local excluded = {
    Trouble = true,
    startuptime = true,
}

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
_G.get_statusline = function()
    -- Get fmt strs from dict and concatenate them into one string.
    -- @param key_list: table of keys to use to access fmt strings
    -- @param dict: associative array to get fmt strings from
    -- @return string of concatenated fmt strings and data that will create the
    -- statusline when evaluated
    local function _concat_status(key_list, str_dict)
        local str_table = {}

        for _, val in ipairs(key_list) do
            table.insert(str_table, str_dict[val])
        end

        return table.concat(str_table, " ")
    end

    --- Predicate fn to check if the current window is where the statusline is being
    --- drawn.
    -- Notes:
    --  should avoid autocommands to track current statusline, see
    --  https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
    --  can track via global vars, see
    --  https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
    local function _is_inactive_win()
        return vim.g.statusline_winid ~= vim.api.nvim_get_current_win()
    end

    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    if _is_inactive_win() then
        return "%#StatusLineNC#"
    elseif excluded[ft] then
        return status_parts["file_name"]
    else
        local status_bg = get_hi("StatusLine").background

        -- store diagnostics and icons, always accessed
        status_parts["diag"] = srcs.get_diagnostics(status_bg)
        status_parts["file_info"] = srcs.get_fileinfo(ft)
        status_parts["icon"] = srcs.get_icon(status_bg)
        status_parts["mod"] = srcs.get_mod(status_bg)

        -- concatenate desired status components into str
        return _concat_status(status_order, status_parts)
    end
end
