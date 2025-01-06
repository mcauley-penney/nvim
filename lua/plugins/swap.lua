return {
  "machakann/vim-swap",
  init = function()
    vim.keymap.set("n", "<left>", "<Plug>(swap-prev)", {})
    vim.keymap.set("n", "<right>", "<Plug>(swap-next)", {})
  end
}
