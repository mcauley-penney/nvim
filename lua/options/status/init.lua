local get_hi = require("utils").get_hi_grp_rgb
local srcs = require("options.status.external_srcs")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_str = {
    ab_path = " %<%F",
    buf_info = nil,
    file_name = " %t",
    icon = nil,
    indent = "%=",
    loc = nil,
    mod = nil,
    ro = "%r",
}

local stl_order = {
    "icon",
    "ab_path",
    "mod",
    "ro",
    "indent",
    "buf_info",
    "loc",
}

local excluded = {
    toggleterm = true,
    Trouble = true,
    startuptime = true,
}

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

--- Predicate fn to check if the current window is where the statusline is
-- being drawn.
-- Notes:
--  Should avoid autocommands to track current statusline, see
--  https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
--
--  Can track via global vars, see
--  https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
local function _is_inactive_win()
    return vim.g.statusline_winid ~= vim.api.nvim_get_current_win()
end

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
_G.get_statusline = function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    if _is_inactive_win() then
        return "%#StatusLineNC#"
    elseif excluded[ft] then
        return stl_str["file_name"]
    else
        -- get background color for statusline
        -- we will use this to hi elements that we are inserting
        local status_bg = get_hi("StatusLine", "bg")
        local mod_str = "%m"
        local loc_str = "%4l/%-4L "

        -- store diagnostics and icons, always accessed
        stl_str["buf_info"] = srcs.get_diag_str(require("lsp").signs, status_bg)
        stl_str["icon"] = srcs.get_ft_icon(ft, status_bg)
        stl_str["mod"] = srcs.get_mod_str(mod_str, status_bg)
        stl_str["loc"] = srcs.get_wordcount_str(loc_str, ft)

        -- concatenate desired status components into str
        return _concat_status(stl_order, stl_str)
    end
end
