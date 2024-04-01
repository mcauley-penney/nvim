return {
  "mcauley-penney/tidy.nvim",
  opts = {
    filetype_exclude = { "diff" }
  },
  init = function()
    vim.keymap.set('n', "<leader>tt", require("tidy").toggle, {})
  end
}
