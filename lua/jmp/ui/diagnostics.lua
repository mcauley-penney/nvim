local style = require("jmp.style")

-- define signs and highlights for diag types
for diag_type, sym in pairs(style.signs) do
  local hl = table.concat({ "DiagnosticSign", diag_type }, "")

  vim.fn.sign_define(hl, { text = sym, texthl = hl })
end

-- configure diagnostics
vim.diagnostic.config({
  float = {
    border = style.border,
    header = "",
    severity_sort = true,
  },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    format = function(diag)
      local prefix = style.icons.diagnostic
      local msg = string.gsub(diag.message, "%s*%c+%s*", ":")
      return string.format("%s [%s] %s", prefix, diag.source, msg)
    end,
    prefix = "",
  },
})
