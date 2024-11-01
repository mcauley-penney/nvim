return {
  "mcauley-penney/tidy.nvim",
  branch = "improved-ft-detect",
  opts = {
    filetype_exclude = { "diff" },
    provide_undefined_editorconfig_behavior = true
  },
  init = function()
    vim.keymap.set('n', "<leader>tt", require("tidy").toggle, {})
  end
}
