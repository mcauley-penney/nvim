return {
  "echasnovski/mini.snippets",
  init = function()
    local snips = require('mini.snippets')
    local gen_loader = snips.gen_loader

    snips.setup({
      snippets = {
        --  gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        gen_loader.from_lang(),
      },
      expand = {
        insert = function(snippet)
          return snips.default_insert(snippet, { empty_tabstop = '○', empty_tabstop_final = '†' })
        end
      }
    })

    vim.api.nvim_set_hl(0, 'MiniSnippetsCurrent', { link = "NONE" })
    vim.api.nvim_set_hl(0, 'MiniSnippetsCurrentReplace', { link = "Operator" })
    vim.api.nvim_set_hl(0, 'MiniSnippetsFinal', { link = "Comment" })
    vim.api.nvim_set_hl(0, 'MiniSnippetsUnvisited', { link = "Comment" })
    vim.api.nvim_set_hl(0, 'MiniSnippetsVisited', { link = "NONE" })
  end
}
