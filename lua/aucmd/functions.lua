local short_indent = {
  ["css"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["json"] = true,
  ["lua"] = true,
  ["org"] = true,
  ["text"] = true,
  ["yaml"] = true,
}

local nonstandard_tw = {
  ["c"] = 120,
  ["cpp"] = 120,
  ["gitcommit"] = 72,
  ["javascript"] = 120,
  ["javascriptreact"] = 120,
  ["json"] = 0,
  ["lua"] = 120,
  ["python"] = 120,
  ["tex"] = 0,
  ["whsp"] = 0,
  ["txt"] = 0
}

local M = {
  set_indent = function(ft)
    local indent = short_indent[ft] and 2 or 4

    for _, opt in ipairs({ "shiftwidth", "softtabstop", "tabstop" }) do
      vim.api.nvim_set_option_value(opt, indent, {})
    end
  end,

  set_textwidth = function(ft)
    local tw = nonstandard_tw[ft] or 80
    tw = tools.nonprog_modes[ft] and 0 or tw

    vim.api.nvim_set_option_value("textwidth", tw, {})
  end,
}

return M
