--[[
    Thanks Iron-E!
    https://gitlab.com/Iron_E/dotfiles/-/blob/b8b8cc921b08d4be84a0dea343ec7cf8698bea14/.config/nvim/lua/init/config.lua#L101
]]

_G.get_fold_text = function()
    local start = vim.v.foldstart

    local first_line_str = vim.api.nvim_buf_get_lines(0, start - 1, start, true)[1]

    local fold_line_count = vim.v.foldend - start

    return string.format("%s {%s more lines}", first_line_str, fold_line_count)
end
