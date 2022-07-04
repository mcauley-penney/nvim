local styles = require("jmp.style")
local hl_dict = styles.palette_grps
local srcs = require("jmp.options.status.external_srcs")

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
    buf_info = nil,
    diag = nil,
    git_branch = nil,
    loc = "%l/%-4L ",
    mod = nil,
    path = " %<%F",
    ro = nil,
    sep = "%=",
}

local stl_order = {
    "git_branch",
    "path",
    "mod",
    "ro",
    "sep",
    "diag",
    "wordcount",
    "loc",
}

local function get_modified(buf)
    if vim.bo[buf].modified then
        return table.concat({ hl_dict["Error"].hl_str, "ﴖ", "%* " })
    end
end

local function is_ro(buf)
    if vim.bo[buf].readonly then
        return table.concat({ hl_dict["Warn"].hl_str, "", "%* " })
    end
end

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
--      1. Should avoid autocommands to track current statusline, see
--      https://github.com/vim/vim/issues/4406#issuecomment-495496763 .
--
--      2. Can track via global vars, see
--      https://www.reddit.com/r/vim/comments/dxcgtm/comment/f7p12hr/?utm_source=share&utm_medium=web2x&context=3
--
_G.get_statusline = function()
    if vim.bo.buftype == "terminal" then
        return "%#StatusLineNC#"
    end

    local curbuf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

    stl_parts["mod"] = get_modified(curbuf)
    stl_parts["ro"] = is_ro(curbuf)

    stl_parts["git_branch"] = srcs.get_git_branch(hl_dict["Success"].hl_str)

    if #vim.lsp.buf_get_clients() > 0 then
        stl_parts["diag"] = srcs.get_diag_str(styles.signs, hl_dict)
    end

    if vim.api.nvim_buf_get_option(0, "filetype") == "txt" then
        stl_parts["wordcount"] = srcs.get_wordcount_str()
    end

    -- concatenate desired status components into str
    return _concat_status(stl_order, stl_parts)
end
