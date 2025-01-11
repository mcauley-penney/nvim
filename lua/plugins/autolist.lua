return {
  "mcauley-penney/autolist.nvim",
  ft = {
    "markdown",
    "plaintex",
    "tex",
    "text",
  },
  config = function()
    require("autolist").setup()

    vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
    vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")

    vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
    vim.keymap.set("n", "m<CR>", "o<cmd>AutolistNewBullet<cr>")
    vim.keymap.set("n", "m<SPACE>", "O<cmd>AutolistNewBulletBefore<cr>")
    vim.keymap.set("n", "<C-Space>", "<cmd>AutolistToggleCheckbox<cr><CR>")
    vim.keymap.set("n", "<leader>lr", "<cmd>AutolistRecalculate<cr>")

    -- cycle list types with dot-repeat
    vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
    vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

    -- functions to recalculate list on edit
    vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
    vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
  end,
}
