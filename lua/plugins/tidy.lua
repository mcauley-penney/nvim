return {
  "mcauley-penney/tidy.nvim",
  branch = "only-modified",
  opts = {
    only_insert_lines = false,
    filetype_exclude = { "diff" },
    provide_undefined_editorconfig_behavior = true
  },
  init = function()
    vim.keymap.set('n', "<leader>tt", require("tidy").toggle, {})
  end
}
