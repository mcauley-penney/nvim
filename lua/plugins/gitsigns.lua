return {
  "lewis6991/gitsigns.nvim",
  opts = {
    attach_to_untracked = false,
    preview_config = {
      border = "solid",
      row = 1,
      col = 1,
    },
    signcolumn = true,
    signs = {
      change = { text = "┋" },
    },
    signs_staged = {
      change = { text = "┋" },
    },
    update_debounce = 500,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "<leader>gb", function() gs.blame_line({ full = false }) end)
      map("n", "<leader>gd", gs.diffthis)
      map("n", "<leader>gD", function() gs.diffthis("~") end)
      map("n", "<leader>gt", gs.toggle_signs)
      map("n", "<leader>hp", gs.preview_hunk)
      map("n", "<leader>hu", gs.undo_stage_hunk)

      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")

      for map_str, fn in pairs({
        ["]h"] = gs.next_hunk,
        ["[h"] = gs.prev_hunk,
      }) do
        map("n", map_str, function()
          if vim.wo.diff then return map_str end
          vim.schedule(function() fn() end)
          return "<Ignore>"
        end, { expr = true })
      end
    end,
  },
}
