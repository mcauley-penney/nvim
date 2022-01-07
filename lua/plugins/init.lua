-- sources
--  1. packer events: https://neovim.io/doc/user/autocmd.html#events

require("plugins.disable")
require("plugins.cfgs.global_cfgs")
require("impatient")

-- putting compiled path in lua folder allows impatient to cache it
local compiled_path = "/lua/plugins/packer/packer_compiled.lua"
compiled_path = vim.fn.stdpath("config") .. compiled_path

local lsp_langs = { "c", "lua", "python", "sh" }

require("packer").startup({
    function(use)
        -- core {{{
        use("wbthomason/packer.nvim")

        use({ "lewis6991/impatient.nvim", rocks = "mpack" })

        use({ "nvim-lua/plenary.nvim", module = "plenary" })

        use({
            "hrsh7th/nvim-cmp",
            config = [[ require "plugins.cfgs.cmp" ]],
            module = "cmp",
            event = "InsertEnter",
            requires = {
                { "hrsh7th/cmp-buffer", event = "InsertEnter" },
                { "hrsh7th/cmp-emoji", event = "InsertEnter", keys = ":" },

                {
                    "petertriho/cmp-git",
                    ft = "gitcommit",
                    event = "InsertEnter",
                    requires = "nvim-lua/plenary.nvim",
                },

                { "kdheepak/cmp-latex-symbols", event = "InsertEnter" },

                {
                    "hrsh7th/cmp-nvim-lsp",
                    ft = lsp_langs,
                    event = "InsertEnter",
                },

                {
                    "hrsh7th/cmp-nvim-lua",
                    ft = "lua",
                    event = "InsertEnter",
                },

                {
                    "hrsh7th/cmp-path",
                    event = "InsertEnter",
                },

                { "hrsh7th/vim-vsnip", event = "InsertEnter" },
                { "hrsh7th/vim-vsnip-integ", event = "InsertEnter" },
                { "hrsh7th/cmp-vsnip", event = "InsertEnter" },
            },
        })

        -- LSP
        use("neovim/nvim-lspconfig")

        use({
            "williamboman/nvim-lsp-installer",
            config = function()
                require("nvim-lsp-installer").on_server_ready(function(server)
                    local default_opts = {
                        on_attach = require("lsp.utils").onAttach,
                    }
                    local server_opts = {
                        ["clangd"] = function()
                            default_opts.settings = {
                                "clangd",
                                "--clang-tidy",
                                "--completion-style=detailed",
                                "--cross-file-rename",
                                "--header-insertion=iwyu",
                                "--header-insertion-decorators",
                                "--limit-results=10",
                                "--pch-storage=memory",
                            }
                        end,

                        ["sumneko_lua"] = function()
                            default_opts.settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    runtime = {
                                        version = "LuaJIT",
                                        path = vim.split(package.path, ";"),
                                    },
                                    telemetry = { enable = false },
                                    workspace = {
                                        library = {
                                            library = vim.api.nvim_get_runtime_file(
                                                "",
                                                true
                                            ),
                                        },
                                    },
                                    format = { enable = true },
                                },
                            }
                        end,
                    }

                    local server_options = server_opts[server.name]
                            and server_opts[server.name]()
                        or default_opts
                    server:setup(server_options)
                end)
            end,
        })

        -- treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            config = [[ require "plugins.cfgs.ts" ]],
            run = ":TSUpdate",
        })

        -- formatting {{
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = [[ require "plugins.cfgs.null" ]],

            -- Note:
            -- 1. keep an eye out for vim.format:
            -- https://www.reddit.com/r/neovim/comments/roixc6/comment/hpzfnss/?utm_source=share&utm_medium=web2x&context=3
        })

        use({
            "mcauley-penney/tidy.nvim",
            event = "BufWritePre",
        })
        -- }} end formatting
        -- }}} end core

        --luxuries {{{

        -- scheme {{
        use("/home/m/files/nonwork/cacophony.nvim")

        use({
            "kyazdani42/nvim-web-devicons",
            config = [[ require "plugins.cfgs.icons" ]],
        })
        -- }} end scheme

        -- vim.cmd("packadd! cfilter")

        use({
            "akinsho/bufferline.nvim",
            config = [[ require "plugins.cfgs.bufferline" ]],
            event = "BufHidden",
        })

        use({
            "lukas-reineke/indent-blankline.nvim",
            config = [[ require "plugins.cfgs.indent_blankline" ]],
        })

        use({ "pedro757/indentInsert.nvim", module = "indentInsert" })

        use({
            "ray-x/lsp_signature.nvim",
            event = "InsertEnter",
            ft = lsp_langs,
            -- Note
            -- 1. keep an eye on anticonceal
            -- 2. for config, see lsp_init
        })

        use({
            "iamcco/markdown-preview.nvim",
            ft = "markdown",
            run = ":call mkdp#util#install()",
        })

        use({
            "windwp/nvim-autopairs",
            config = [[ require "plugins.cfgs.pairs" ]],
            event = "InsertEnter",
        })

        use({
            "norcalli/nvim-colorizer.lua",
            config = [[ require "plugins.cfgs.colorizer" ]],
            ft = { "lua", "css" },
        })

        use({
            "blackCauldron7/surround.nvim",
            config = function()
                require("surround").setup({
                    mappings_style = "sandwich",
                    prefix = "<F14>",
                })
            end,
        })

        -- use({ "simrat39/symbols-outline.nvim", ft = lsp_langs })

        use("wellle/targets.vim")

        use({
            "akinsho/toggleterm.nvim",
            config = [[ require "plugins.cfgs.toggleterm" ]],
            keys = "<C-space>",
        })

        use({
            "folke/trouble.nvim",
            config = [[ require "plugins.cfgs.trouble" ]],
            cmd = "TroubleToggle",
        })

        use({
            "kkoomen/vim-doge",
            ft = lsp_langs,
            run = ":call doge#install()",
        })

        use({ "itchyny/vim-highlighturl" })

        use({ "rrethy/vim-illuminate", event = "CursorHold" })

        use("sickill/vim-pasta")

        use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

        use({
            "gbprod/substitute.nvim",
            config = function()
                require("substitute").setup()
            end,
        })

        use({ "machakann/vim-swap", keys = { "g<", "g>" } })

        use({
            "chaoren/vim-wordmotion",
            keys = { "b", "c", "d", "k", "w", "y" },
        })

        use({
            "lukas-reineke/virt-column.nvim",
            config = function()
                require("virt-column").setup({ char = "│" })
            end,
            event = "InsertEnter",
        })

        -- }}} end luxuries

        -- Testing
    end,

    -- Packer configuration
    config = {
        compile_path = compiled_path,
        display = {
            header_sym = "",
            open_fn = function()
                return require("packer.util").float({ border = "none" })
            end,
        },
    },
})

-- load plugins from chosen location
if not vim.g.packer_compiled_loaded then
    vim.cmd(string.format("source %s", compiled_path))
    vim.g.packer_compiled_loaded = true
end
