local M = {}

local get_hl = require("utils").get_hl_grp_rgb
local set_hl = require("options.status.hl").make_hl_def_bg
local srcs = require("options.status.external_srcs")

local excluded = {
    OUTLINE = true,
    trouble = true,
    startuptime = true,
}

local hl_mtbl = {
    Info = set_hl({ grp = "StatusBlu", fg = get_hl("DiagnosticInfo", "fg") }),
    Success = set_hl({ grp = "StatusGrn", fg = "#347d39" }),
    Error = set_hl({ grp = "StatusRed", fg = get_hl("DiagnosticError", "fg") }),
    Warn = set_hl({ grp = "StatusYlw", fg = get_hl("DiagnosticWarn", "fg") }),
    Hint = set_hl({ grp = "StatusWht", fg = get_hl("DiagnosticHint", "fg") }),
}

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_str = {
    ab_path = " %<%F",
    buf_info = nil,
    file_name = " %t",
    icon = nil,
    indent = "%=",
    loc = "%4l/%-4L ",
    mod = table.concat({ hl_mtbl.Error, "%m", "%* " }, ""),
    ro = table.concat({ hl_mtbl.Error, "%r", "%* " }, ""),
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

-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function _concat_status(order_tbl, stl_part_tbl)
    local str_table = {}

    for _, val in ipairs(order_tbl) do
        table.insert(str_table, stl_part_tbl[val])
    end

    return table.concat(str_table, " ")
end

-- Top level function called in options.init to get statusline.
-- @return str: statusline text to be displayed
--
-- NOTES:
--  • tracking window status
--  1. Should avoid autocommands to track current statusline, see
--  https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
--  2. Can track via global vars, see
--  https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
--
_G.get_statusline = function()
    local buf = vim.api.nvim_buf_get_name(0)
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    if vim.api.nvim_get_current_win() ~= vim.g.statusline_winid then
        return "%#StatusLineNC#"
    elseif excluded[buf] then
        return stl_str["file_name"]
    else
        stl_str["icon"] = srcs.get_ft_icon(buf, ft)

        if vim.lsp.get_client_by_id(1) ~= nil then
            stl_str["buf_info"] = srcs.get_diag_str(
                require("lsp").signs,
                hl_mtbl
            )
        else
            stl_str["buf_info"] = srcs.get_wordcount_str()
        end

        -- concatenate desired status components into str
        return _concat_status(stl_order, stl_str)
    end
end

return M
