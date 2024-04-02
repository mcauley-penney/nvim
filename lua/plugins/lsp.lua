return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig.ui.windows").default_options.border = tools.ui.cur_border
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
  end,
  dependencies = {
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-emoji",

        {
          "petertriho/cmp-git",
          dependencies = "nvim-lua/plenary.nvim",
          config = true,
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
      config = function()
        local cmp = require("cmp")
        local compare = cmp.config.compare
        local pad_len = 2

        --[[
          Get completion context, such as namespace where item is from.
          Depending on the LSP, this information is stored in different places.
          The process to find them is very manual: log the payloads And see where useful information is stored.

          See https://www.reddit.com/r/neovim/comments/128ndxk/comment/jen9444/?utm_source=share&utm_medium=web2x&context=3
      ]]
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

            local i, j = string.find(import_str, "[\"<].*[\">]")
            if i == nil then return end

            return string.sub(import_str, i, j)
          end
        end

        cmp.setup({
          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
              local choice = require("lspkind").cmp_format({
                ellipsis_char = tools.ui.icons.ellipses,
                maxwidth = 25,
                mode = "symbol",
              })(entry, vim_item)

              choice.abbr = vim.trim(choice.abbr)
              choice.menu = ""

              local cmp_ctx = get_lsp_completion_context(entry.completion_item, entry.source)
              if cmp_ctx ~= nil and cmp_ctx ~= "" then
                choice.menu = table.concat({ "  → ", cmp_ctx })
              end

              choice.menu = choice.menu .. string.rep(" ", pad_len)

              return choice
            end,
          },
          mapping = {
            ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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
              compare.score,
              compare.offset,
              compare.recently_used,
              compare.order,
              compare.exact,
              compare.kind,
              compare.locality,
              compare.length,
              -- copied from TJ Devries; cmp-under
              function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find "^_+"
                local _, entry2_under = entry2.completion_item.label:find "^_+"
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                  return false
                elseif entry1_under < entry2_under then
                  return true
                end
              end,
            },
          },
          sources = {
            { name = "luasnip" },
            { name = "nvim_lsp", max_item_count = 20 },
            { name = "nvim_lua", max_item_count = 20 },
            { name = "buffer",   max_item_count = 20 },
            { name = 'orgmode' },
            { name = "path" },
            { name = 'emoji' },
            { name = "git" },
            {
              name = "latex_symbols",
              max_item_count = 10,
              option = {
                strategy = 0, -- mixed
              },
            },
          },
          view = {
            entries = {
              follow_cursor = true,
            }
          },
          window = {
            documentation = {
              border = tools.ui.cur_border,
              max_height = 75,
              max_width = 75,
            },
            completion = {
              border = tools.ui.cur_border,
              col_offset = 1,
              scrolloff = 10,
              side_padding = pad_len,
            }
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

    },

    {
      "williamboman/mason.nvim",
      opts = {
        max_concurrent_installers = 20,
        ui = {
          border = tools.ui.cur_border,
          height = 0.8,
          icons = {
            package_installed = tools.ui.icons.bullet,
            package_pending = tools.ui.icons.ellipses,
            package_uninstalled = tools.ui.icons.o_bullet,
          },
        }
      },
    },

    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "clangd",
          "dockerls",
          "jsonls",
          "lua_ls",
          "pyright",
          "tsserver"
        },
      },
      init = function()
        local populate_setup = function(servers_tbl, attach_fn)
          local init_server = function(server_name, server_cfg, attach, default_caps)
            server_cfg.on_attach = attach
            --  server_cfg.hints = { enabled = true }
            server_cfg.capabilities = default_caps
            require("lspconfig")[server_name].setup(server_cfg)
          end

          local caps = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
            require('cmp_nvim_lsp').default_capabilities(),
            {
              textDocument = {
                completion = {
                  completionItem = {
                    snippetSupport = true
                  }
                },
                foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true
                }
              },
            }
          )

          local setup_tbl = {
            function(server_name)
              init_server(server_name, {}, attach_fn, caps)
            end
          }

          for name, cfg in pairs(servers_tbl) do
            setup_tbl[name] = function()
              init_server(name, cfg, attach_fn, caps)
            end
          end

          return setup_tbl
        end

        local lsp = require("lsp")
        require("mason-lspconfig").setup_handlers(populate_setup(lsp.servers, lsp.on_attach))
      end
    },

    {
      "nvimtools/none-ls.nvim",
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {
        debounce = 300,
        on_attach = require("lsp").on_attach
      }
    },

    {
      'jay-babu/mason-null-ls.nvim',
      opts = {
        automatic_installation = true,
        ensure_installed = {
          "actionlint",
          "black",
        },
        handlers = {}
      }
    },

    {
      "folke/neodev.nvim",
      ft = "lua",
    },

    {
      "onsails/lspkind.nvim",
      config = function()
        local lspkind = require('lspkind')

        for _, tbl in pairs(lspkind.presets) do
          for name, icon in pairs(tbl) do
            tbl[name] = icon .. ' '
          end
        end

        lspkind.init({
          preset = "codicons",
        })
      end,
    },

    {
      "j-hui/fidget.nvim",
      opts = {
        progress = {
          suppress_on_insert = true,
          display = {
            done_ttl = 2,
            progress_icon = { pattern = "grow_horizontal", period = 0.75 },
          },
        },
        notification = {
          window = {
            border = tools.ui.cur_border,
            normal_hl = "NormalFloat",
            winblend = 0
          }
        }
      }
    }
  }
}
