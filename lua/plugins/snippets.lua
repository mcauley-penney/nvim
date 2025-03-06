return {
  "echasnovski/mini.snippets",
  opts = {
    snippets = {
      --  gen_loader.from_file('~/.config/nvim/snippets/global.json'),
      require('mini.snippets').gen_loader.from_lang(),
    },
    mappings = {
      stop = '<C-c>'
    },
    expand = {
      insert = function(snippet)
        return require('mini.snippets').default_insert(snippet, {
          empty_tabstop = '',
          empty_tabstop_final = '†'
        })
      end
    }
  },
  config = function(_, opts)
    require('mini.snippets').setup(opts)

    vim.api.nvim_set_hl(0, 'MiniSnippetsFinal', { link = "Comment" })
  end,
}
