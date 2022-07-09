local border = require("jmp.style").border

-- https://github.com/askfiy/nvim/blob/74c4a2e1f03e7940c4efcc69d2d4eab736dbc7d3/lua/configure/plugins/nv_nvim-lsp-installer.lua
local lsp_signature_help = function(_, result, ctx, config)
  -- Add file type for LSP signature help
  local bufnr, winnr = vim.lsp.handlers.signature_help(_, result, ctx, config)

  if not bufnr or not winnr then
    return
  end

  -- Put the signature floating window above the cursor
  local cur_cursor_ln = vim.api.nvim_win_get_cursor(0)[1]
  local win_height = vim.api.nvim_win_get_height(winnr)

  if cur_cursor_ln > win_height + 2 then
    vim.api.nvim_win_set_config(winnr, {
      anchor = "SW",
      border = border,
      relative = "cursor",

      -- place float one line above the current line
      -- and one col to the right of the cursor
      row = 0,
      col = 1,
    })
  else
    vim.api.nvim_win_set_config(winnr, {
      anchor = "NW",
      border = border,
      relative = "cursor",

      -- place float one line above the current line
      -- and one col to the right of the cursor
      row = 1,
      col = 1,
    })
  end

  vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
  return bufnr, winnr
end

-- override handlers
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(
    lsp_signature_help,
    {
      close_events = { "InsertLeavePre" },
      filetype = "lsp-signature-help",
      focus = false,
      silent = true,
    }
  )

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers["hover"],
  { border = border }
)
