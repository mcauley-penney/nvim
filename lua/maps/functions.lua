local dash = "- "
local fslash = "// "

local ft_cstr_overrides = {
  ["c"] = fslash,
  ["cpp"] = fslash,
  ["txt"] = dash,
  ["text"] = dash
}


local unwrap_cstr = function(cstr)
  local left, right = string.match(cstr, '(.*)%%s(.*)')
  return vim.trim(left), vim.trim(right)
end

local M = {
  send_comment = function()
    -- check our commentstring override map
    local ft = vim.api.nvim_get_option_value("filetype", {})
    local cstr = ft_cstr_overrides[ft]
    if (cstr ~= nil) then return cstr end

    cstr = vim.bo.commentstring
    if cstr == "" or cstr == nil then
      return dash
    end

    -- if we haven't overridden the current commentstring, return it
    local row, col
    local pos_tbl = vim.api.nvim_win_get_cursor(0)

    row = pos_tbl[1] - 1
    col = pos_tbl[2]


    local left_cstr, right_cstr = unwrap_cstr(cstr)
    local inc_len = string.find(cstr, "%s*%%s") - 1

    vim.schedule(function()
      vim.api.nvim_buf_set_text(0, row, col, row, col, { left_cstr .. "  " .. right_cstr })
      vim.api.nvim_win_set_cursor(0, { row + 1, col + inc_len + 1 })
    end)
  end,
}

return M
