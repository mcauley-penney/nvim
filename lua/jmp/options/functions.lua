local icons = require("jmp.style.init")["icons"]

_G.get_fold_text = function()
  local tab_len = vim.api.nvim_buf_get_option(0, "softtabstop")
  local num_spaces = math.floor(vim.v.foldlevel * tab_len)
  local indent = string.rep(" ", num_spaces)

  return string.format(
    "%s%s %s",
    indent,
    icons["fold"],
    vim.v.foldend - vim.v.foldstart + 1
  )
end
