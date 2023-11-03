return {
  -- https://www.reddit.com/r/vim/comments/k10psl/how_to_convert_smart_quotes_and_other_fancy/
  --  "idbrii/vim-textconv",

  {
    'Bekaboo/dropbar.nvim',
    opts = {
      general = {
        update_interval = 100,
      },
      bar = {
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
        ui = { bar = { separator = ' ' .. tools.ui.icons.r_chev .. '  ' } },
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

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  {
    'lukas-reineke/headlines.nvim',
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("headlines").setup({
        markdown = {
          dash_string = "-",
          quote_string = "┃",
          fat_headlines = false,
          fat_headline_upper_string = "▃",
          fat_headline_lower_string = "🬂",
        },
        org = {
          fat_headlines = false,
        },

        quarto = {
          query = vim.treesitter.query.parse(
            "markdown",
            [[
							(atx_heading [
								(atx_h1_marker)
								(atx_h2_marker)
								(atx_h3_marker)
								(atx_h4_marker)
								(atx_h5_marker)
								(atx_h6_marker)
							] @headline)

							(thematic_break) @dash

							(fenced_code_block) @codeblock

							(block_quote_marker) @quote
							(block_quote (paragraph (inline (block_continuation) @quote)))
						]]
          ),

          treesitter_language = "markdown",
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          quote_highlight = "Quote",
          quote_string = "┃",
          fat_headlines = false,
        },
      })

      vim.api.nvim_set_hl(0, "CodeBlock", { link = "StatusLine" })
    end
  },

  {
    "dhruvasagar/vim-table-mode",
  },

  {
    "aaron-p1/match-visual.nvim",
    opts = {
      min_length = 3
    },
  },
}
