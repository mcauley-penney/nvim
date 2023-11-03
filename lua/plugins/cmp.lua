return {
  {
    "mcauley-penney/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      local window_opts = {
        border = tools.ui.border,
        max_height = 75,
        max_width = 75,
        winhighlight = table.concat({
            'Normal:NormalFloat',
            'FloatBorder:FloatBorder',
          },
          ','
        ),
      }

      --- Get completion context, i.e., auto-import/target module location.
      --- Depending on the LSP this information is stored in different parts of the
      --- lsp.CompletionItem payload. The process to find them is very manual: log the payloads
      --- And see where useful information is stored.
      ---@see https://www.reddit.com/r/neovim/comments/128ndxk/comment/jen9444/?utm_source=share&utm_medium=web2x&context=3
      local function get_lsp_completion_context(completion, source)
        local ok, source_name = pcall(function() return source.source.client.config.name end)
        if not ok then return nil end

        if source_name == "tsserver" then
          return completion.detail
        elseif source_name == "pyright" then
          if completion.labelDetails ~= nil then return completion.labelDetails.description end
        elseif source_name == "clangd" then
          local doc = completion.documentation
          if doc == nil then return end

          local import_str = doc.value

          local i, j = string.find(import_str, "<.*>")
          if i == nil then return end

          return string.sub(import_str, i, j)
        end
      end

      cmp.setup({
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            local choice = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 35,
            })(entry, vim_item)

            choice.abbr = ' ' .. vim.trim(choice.abbr) .. ' '
            choice.menu = ""

            local cmp_ctx = get_lsp_completion_context(entry.completion_item, entry.source)
            if cmp_ctx ~= nil and cmp_ctx ~= "" then
              choice.menu = table.concat({ ' → ', cmp_ctx })
            end

            choice.menu = choice.menu .. ' '

            return choice
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        },
        matching = {
          disallow_fuzzy_matching = false,
          disallow_fullfuzzy_matching = false,
          disallow_partial_fuzzy_matching = false,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- source: https://github.com/gennaro-tedesco/dotfiles/blob/4a175cce9f8f445543ac61cc6c4d6a95d6a6da10/nvim/lua/plugins/cmp.lua#L79-L88
        -- needs testing
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
          },
        },
        sources = {
          { name = "nvim_lsp", max_item_count = 20 },
          { name = "nvim_lua", max_item_count = 20 },
          { name = "luasnip" },
          { name = "buffer",   max_item_count = 5 },
          { name = 'orgmode' },
          { name = "path" },
          {
            name = "latex_symbols",
            max_item_count = 10,
            option = {
              strategy = 0, -- mixed
            },
          },
          { name = 'emoji' },
          { name = "git" },
          { name = "latex_symbols" },
        },
        view = {
          entries = {
            follow_cursor = true
          }
        },
        window = {
          documentation = window_opts,
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline', max_item_count = 20 },
          { name = 'path',    max_item_count = 1 },
        }),
      })

      for k, v in pairs({
        CmpItemAbbrMatch      = "Number",
        CmpItemAbbrMatchFuzzy = "CmpItemAbbrMatch",
        CmpItemKindInterface  = "CmpItemKindVariable",
        CmpItemKindText       = "CmpItemKindVariable",
        CmpItemKindMethod     = "CmpItemKindFunction",
        CmpItemKindProperty   = "CmpItemKindKeyword",
        CmpItemKindUnit       = "CmpItemKindKeyword",
      }) do
        vim.api.nvim_set_hl(0, k, { link = v })
      end

      -- Use autopairs for adding parenthesis to function completions
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",

      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup()
        end,
        requires = "nvim-lua/plenary.nvim",
        ft = "gitcommit"
      },

      "kdheepak/cmp-latex-symbols",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },
  }
}
