local function lens(render, pos_list, nearest, wkg_i, _)
  local hl = "Folded"
  local chunks

  local cur_ratio = (' %d/%d '):format(wkg_i, #pos_list)
  chunks = { { '  ', 'Ignore' }, { cur_ratio, hl } }

  local lnum, col = pos_list[wkg_i][1], pos_list[wkg_i][2]
  render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
end

return {
  'kevinhwang91/nvim-hlslens',
  opts = {
    calm_down = true,
    override_lens = lens
  },
  init = function()
    local map = vim.api.nvim_set_keymap
    local kopts = { noremap = true, silent = true }

    map('n', 'j',
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
    map('n', 'J',
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
    map('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    map('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    map('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    map('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

    map('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
  end
}
