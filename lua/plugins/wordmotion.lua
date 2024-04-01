return {
  "chaoren/vim-wordmotion",
  init = function()
    vim.g.wordmotion_mappings = { e = "k", ge = "gk" }
  end
}
