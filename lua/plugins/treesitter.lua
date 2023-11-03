return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "diff",
          "dockerfile",
          "gitcommit",
          "git_config",
          "git_rebase",
          "html",
          "http",
          "javascript",
          "json",
          "latex",
          "lua",
          "luadoc",
          "make",
          "markdown",
          "markdown_inline",
          "org",
          "python",
          "r",
          "regex",
          "ssh_config",
          "vimdoc",
          "yaml"
        },
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- List of parsers to ignore installing
        ignore_install = {},
        highlight = {
          -- Setting this to true will run `:h syntax` and tree-sitter at the
          -- same time. Set this to `true` if you depend on 'syntax' being
          -- enabled (like for indentation). Using this option may slow down your
          -- editor, and you may see some duplicate highlights. Instead of true
          -- it can also be a list of languages
          enable = true,
          -- ORG: Required for spellcheck, some LaTex highlights and code
          -- block highlights that do not have ts grammar
          additional_vim_regex_highlighting = { 'org' },
        },
        textobjects = {
          lookahead = true,

          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },

          select = {
            enable = true,
            keymaps = {
              ["iC"] = "@call.inner",
              ["aC"] = "@call.outer",
              ["ic"] = "@conditional.inner",
              ["ac"] = "@conditional.outer",
              ["if"] = "@function.inner",
              ["af"] = "@function.outer",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
            },
          },

          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@function.outer",
            },
            swap_previous = {
              ["<leader>A"] = "@function.outer",
            },
          },
        },
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "danymat/neogen",
    config = {
      languages = {
        lua = {
          template = {
            annotation_convention = "ldoc",
          },
        },
        python = {
          template = {
            annotation_convention = "numpydoc",
          },
        },
      },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.keymap.set("n", "<leader>id", require('neogen').generate, {})
    end
  },

  {
    "echasnovski/mini.splitjoin",
    config = function()
      local MiniSplitjoin = require('mini.splitjoin')

      local pairs = {
        '%b()',
        '%b<>',
        '%b[]',
        '%b{}',
      }

      MiniSplitjoin.setup({
        detect = {
          brackets = pairs,
          separator = '[,;]',
          exclude_regions = {},
        },
        mappings = {
          toggle = 'gS',
        },
      })

      local gen_hook = MiniSplitjoin.gen_hook
      local hook_pairs = { brackets = pairs }
      local add_pair_commas = gen_hook.add_trailing_separator(hook_pairs)
      local del_pair_commas = gen_hook.del_trailing_separator(hook_pairs)
      vim.b.minisplitjoin_config = {
        split = { hooks_post = { add_pair_commas } },
        join  = { hooks_post = { del_pair_commas } },
      }
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
