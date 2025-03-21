local function lens(render, pos_list, nearest, wkg_i, relIdx)
  local hl = "NonText"
  local sfw = vim.v.searchforward == 1
  local indicator, text, chunks
  local abs_rel_idx = math.abs(relIdx)

  if abs_rel_idx > 1 then
    indicator = (' %d%s'):format(abs_rel_idx, sfw ~= (relIdx > 1) and '↑' or '↓')
  else
    indicator = ''
  end

  local lnum, col = pos_list[wkg_i][1], pos_list[wkg_i][2]
  local total = #pos_list
  local cur_ratio = (' [%d/%d] '):format(wkg_i, total)

  if nearest then
    text = cur_ratio
    chunks = { { ' ', 'Ignore' }, { text, hl } }
  else
    text = ('%s%s'):format(indicator, cur_ratio)
  end

  chunks = { { ' ', 'Ignore' }, { text, hl } }

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
