-- https://github.com/seblj/dotfiles/blob/master/nvim/lua/config/lspconfig/signature.lua
local M = {}

local check_trigger_char = function(line_to_cursor, triggers)
  if not triggers then
    return false
  end

  for _, trigger_char in ipairs(triggers) do
    local cursor_index = #line_to_cursor
    local current_char = line_to_cursor:sub(cursor_index, cursor_index)

    if current_char == trigger_char then
      return true
    end

    local prev_char = line_to_cursor:sub(cursor_index - 1, cursor_index - 1)

    if current_char == " " and prev_char == trigger_char then
      return true
    end
  end
  return false
end

local open_signature = function(clients)
  local activated = false

  for _, client in pairs(clients) do
    local triggers =
    client.server_capabilities.signatureHelpProvider.triggerCharacters

    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local line_to_cursor = line:sub(1, pos[2])

    if not activated then
      activated = check_trigger_char(line_to_cursor, triggers)
    end
  end

  if activated then
    local params = require("vim.lsp.util").make_position_params()
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params)
  end
end

M.setup = function(client)
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  local clients = {}

  table.insert(clients, client)

  local group = augroup("LspSignature", { clear = false })

  vim.api.nvim_clear_autocmds({ group = group, pattern = "<buffer>" })

  autocmd("TextChangedI", {
    group = group,
    pattern = "<buffer>",
    callback = function()
      if #vim.lsp.get_active_clients() > 0 then
        open_signature(clients)
      end
    end,
  })
end

return M
