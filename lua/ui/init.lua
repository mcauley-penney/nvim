require("ui.statusline")

vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  float = {
    header = ' ',
    border = tools.ui.cur_border,
    source = 'if_many',
    title = { { ' 󰌶 Diagnostics ', 'FloatTitle' } },
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local severity = vim.diagnostic.severity[diag.severity]
      local level = severity:sub(1, 1) .. severity:sub(2):lower()
      local prefix = string.format(" %s  ", tools.ui.lsp_signs[level])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
})
