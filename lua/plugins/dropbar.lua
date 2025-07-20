return {
  "Bekaboo/dropbar.nvim",
  opts = {
    icons = {
      ui = { bar = { separator = " " .. tools.ui.icons.r_chev } },
      kinds = {
        symbols = tools.ui.kind_icons_spaced,
      },
    },
    bar = {
      enable = function(buf, win, _)
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ""
          or vim.wo[win].winbar ~= ""
          or vim.bo[buf].ft == "help"
        then
          return false
        end

        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
        if stat and stat.size > 1024 * 1024 then return false end

        return vim.bo[buf].ft == "markdown"
          or vim.bo[buf].ft == "text"
          or vim.bo[buf].bt == ""
          or pcall(vim.treesitter.get_parser, buf)
          or not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = "textDocument/documentSymbol",
          }))
      end,
      update_debounce = 100,
      sources = function(buf, _)
        local sources = require("dropbar.sources")
        local utils = require("dropbar.utils")

        if vim.bo[buf].ft == "markdown" then return { sources.markdown } end
        if vim.bo[buf].buftype == "terminal" then
          return { sources.terminal }
        end
        return {
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
      end,
    },
  },
}
