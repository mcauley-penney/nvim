return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    opts = {
      sync_install = false,
      ignore_install = {},
      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = false },
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
        swap = { enable = false },
      },
    },
    config = function(_, opts)
      local ensure_installed = {
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
        "yaml",
      }

      local installed = require("nvim-treesitter").get_installed()

      local to_install = vim
        .iter(ensure_installed)
        :filter(
          function(parser) return not vim.tbl_contains(installed, parser) end
        )
        :totable()

      for _, parser in pairs(to_install) do
        require("nvim-treesitter.install").install(parser)
      end

      require("nvim-treesitter").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    branch = "main",
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
      vim.keymap.set("n", "<leader>id", require("neogen").generate, {})
    end,
  },

  {
    "echasnovski/mini.splitjoin",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      local MiniSplitjoin = require("mini.splitjoin")

      local pairs = {
        "%b()",
        "%b<>",
        "%b[]",
        "%b{}",
      }

      MiniSplitjoin.setup({
        detect = {
          brackets = pairs,
          separator = "[,;]",
          exclude_regions = {},
        },
        mappings = {
          toggle = "gS",
        },
      })

      local gen_hook = MiniSplitjoin.gen_hook
      local hook_pairs = { brackets = pairs }
      local add_pair_commas = gen_hook.add_trailing_separator(hook_pairs)
      local del_pair_commas = gen_hook.del_trailing_separator(hook_pairs)
      vim.b.minisplitjoin_config = {
        split = { hooks_post = { add_pair_commas } },
        join = { hooks_post = { del_pair_commas } },
      }
    end,
  },
}
