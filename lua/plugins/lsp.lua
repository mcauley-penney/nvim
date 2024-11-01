return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig.ui.windows").default_options.border = tools.ui.cur_border
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
  end,
  dependencies = {
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
          "ts_ls"
        },
      },
      init = function()
        local populate_setup = function(servers_tbl, attach_fn)
          local init_server = function(server_name, server_cfg, attach, default_caps)
            server_cfg.on_attach = attach
            server_cfg.hints = { enabled = true }
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
      "folke/lazydev.nvim",
      ft = "lua",
    },

    {
      "onsails/lspkind.nvim",
      config = function()
        local lspkind = require('lspkind')

        for _, tbl in pairs(lspkind.presets) do
          for name, icon in pairs(tbl) do
            tbl[name] = table.concat({ ' ', icon, ' ' })
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
            done_style = "NonText",
            group_style = "NonText",
            icon_style = "NonText",
            progress_style = "NonText"
          },
        },
        notification = {
          window = {
            border = tools.ui.cur_border,
            border_hl = "NonText",
            normal_hl = "NonText",
            winblend = 0,
          }
        }
      }
    },

    {
      'Wansmer/symbol-usage.nvim',
      event = 'LspAttach',
      opts = {
        hl = { link = 'NonText' },
        references = { enabled = true, include_declaration = false },
        definition = { enabled = true },
        implementation = { enabled = true }
      },
    }
  }
}
