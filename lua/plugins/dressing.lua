return {
  'stevearc/dressing.nvim',
  config = function()
    require('dressing').setup({
      input = {
        enabled = true,
        insert_only = false,
        start_in_insert = false,
        prefer_width = 25,
        max_width = { 80, 0.5 },
        min_width = { 10, 0.2 },
      },
      select = {
        enabled = true,
        backend = {
          "fzf_lua",
          "builtin",
        },
      }
    })
  end
}
