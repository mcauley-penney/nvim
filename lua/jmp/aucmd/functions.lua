local std = 80

local indent_tbl = {
  ["lua"] = 2,
}

local tw_tbl = {
  ["c"] = std,
  ["cpp"] = std,
  ["gitcommit"] = 50,
  ["lua"] = std,
  ["python"] = std,
  ["sh"] = std,
}

local M = {
  set_indent = function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    local indent = indent_tbl[ft]

    for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
      vim.api.nvim_buf_set_option(0, opt, indent or 4)
    end
  end,

  set_textwidth = function()
    -- get filetype
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    -- set textwidth
    vim.api.nvim_buf_set_option(0, "textwidth", tw_tbl[ft] or 0)
  end,
}

return M
