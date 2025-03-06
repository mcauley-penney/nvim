return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
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
        "printf",
        "python",
        "regex",
        "ssh_config",
        "svelte",
        "typescript",
        "vimdoc",
        "yaml"
      },
      sync_install = false,
      ignore_install = {},
      highlight = { enable = true, },
      fold = { enable = true, },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      textobjects = {
        lookahead = true,
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]c"] = "@class.outer",
            ["]f"] = "@function.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]["] = "@class.outer",
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[c"] = "@class.outer",
            ["[f"] = "@function.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["]F"] = "@function.outer",
            ["[C"] = "@class.outer",
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
        swap = { enable = false, },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "danymat/neogen",
    opts = {
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
    config = function(_, opts)
      require("neogen").setup(opts)
      vim.keymap.set("n", "<leader>id", require('neogen').generate, {})
    end
  },

  {
    "echasnovski/mini.splitjoin",
    dependencies = "nvim-treesitter/nvim-treesitter",
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
  },

  {
    "Bekaboo/dropbar.nvim",
    opts = {
      bar = {
        update_debounce = 100,
        sources = function(buf, _)
          local sources = require('dropbar.sources')
          local utils = require('dropbar.utils')

          if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
          if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
          return {
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end
      },
      icons = {
        ui = { bar = { separator = ' ' .. tools.ui.icons.r_chev .. ' ' } },
      }
    },
    config = function(opts)
      local dropbar_icons = require('dropbar.configs').opts.icons.kinds.symbols
      local lspkind_icons = require("lspkind").symbol_map

      local joined_icons = vim.tbl_extend("force", dropbar_icons, lspkind_icons)
      joined_icons = vim.tbl_map(function(value) return value .. ' ' end, joined_icons)

      opts.opts.icons["kinds"] = {
        symbols = joined_icons
      }
      require("dropbar").setup(opts.opts)
    end
  },
}
