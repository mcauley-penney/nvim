require("ui.statusline")

local S = vim.diagnostic.severity

vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  float = {
    header = ' ',
    border = tools.ui.cur_border,
    source = 'if_many',
    title = { { ' 󰌶 Diagnostics ', 'FloatTitle' } },
    prefix = function(diag)
      local lsp_sym = tools.ui.lsp_signs[diag.severity].sym
      local prefix = string.format(" %s  ", lsp_sym)

      local severity = vim.diagnostic.severity[diag.severity]
      local diag_hl_name = severity:sub(1, 1) .. severity:sub(2):lower()
      return prefix, 'Diagnostic' .. diag_hl_name:gsub('^%l', string.upper)
    end,
  },
  signs = {
    text = {
      [S.INFO] = tools.ui.icons.info_i,
      [S.HINT] = tools.ui.icons.info_i,
      [S.WARN] = tools.ui.icons.up_tri,
      [S.ERROR] = tools.ui.icons.ballot_x
    }
  }
})
