local S = vim.diagnostic.severity
local icons = tools.ui.icons

local lsp_signs = {
  [S.ERROR] = { name = "Error", sym = icons["error"] },
  [S.WARN] = { name = "Warn", sym = icons["warning"] },
  [S.INFO] = { name = "Info", sym = icons["info"] },
  [S.HINT] = { name = "Hint", sym = icons["info"] },
}

vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  virtual_text = {
    prefix = "",
    format = function(diag)
      local clean_src_names = {
        ["Lua Diagnostics."] = "lua",
        ["Lua Syntax Check."] = "lua",
      }

      local msg
      if not diag.code then return " " end

      msg = diag.message

      if diag.source then
        msg = string.format(
          "%s [%s]",
          msg,
          clean_src_names[diag.source] or diag.source
        )
      end

      return msg
    end,
  },
  float = {
    header = " ",
    source = "if_many",
    title = " Diagnostics ",
    prefix = function(diag)
      local lsp_sym = lsp_signs[diag.severity].sym
      local prefix = string.format(" %s  ", lsp_sym)

      local severity = vim.diagnostic.severity[diag.severity]
      local diag_hl_name = severity:sub(1, 1) .. severity:sub(2):lower()
      return prefix, "Diagnostic" .. diag_hl_name:gsub("^%l", string.upper)
    end,
  },
  signs = {
    text = {
      [S.ERROR] = icons.error,
      [S.HINT] = icons.info,
      [S.INFO] = icons.info,
      [S.WARN] = icons.warning,
    },
  },
})

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
