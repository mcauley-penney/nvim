return {
  "simnalamburt/vim-mundo",
  init = function()
    vim.g.mundo_header = 0
    vim.g.mundo_preview_bottom = 1
    vim.g.mundo_right = 1
    vim.g.mundo_verbose_graph = 0

    vim.g.mundo_mappings = {
      ["<cr>"] = "preview",
      e = "mode_newer",
      n = "mode_older",
      q = "quit",
      ["<esc>"] = "quit",
    }

    vim.keymap.set("n", "<leader>u", "<cmd>MundoToggle<cr>", {})
  end,
}
