--  aucmds: https://neovim.io/doc/user/autocmd.html#events
local lsp_langs = require("lsp").langs

-- putting compiled path in lua folder allows impatient to cache it
local compiled = "/lua/plugins/packer_compiled.lua"
compiled = vim.fn.stdpath("config") .. compiled

local function cfg(name)
    return string.format([[require 'plugins.cfg.%s']], name)
end

require("packer").startup({
    function(use)
        --------------------------------------------------
        -- testing
        --------------------------------------------------
        use({
            "kyazdani42/nvim-tree.lua",
            config = function()
                require("nvim-tree").setup({
                    renderer = {
                        add_trailing = true,
                    },
                })
            end,
            requires = {
                "kyazdani42/nvim-web-devicons", -- optional, for file icon
            },
            cmd = "NvimTreeToggle",
        })

        --------------------------------------------------
        -- core
        --------------------------------------------------
        use("wbthomason/packer.nvim")

        use("lewis6991/impatient.nvim")

        use("nathom/filetype.nvim")

        use({ "nvim-lua/plenary.nvim", module = "plenary" })

        use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

        --------------------------------------------------
        -- LSP
        --------------------------------------------------
        use({
            "neovim/nvim-lspconfig",
            config = cfg("lspconfig"),
        })

        use({
            "williamboman/nvim-lsp-installer",
            config = require("nvim-lsp-installer").setup({
                ui = {
                    icons = {
                        server_installed = "✓",
                        server_pending = "►",
                        server_uninstalled = "✗",
                    },
                },
            }),
        })

        --------------------------------------------------
        -- treesitter
        --------------------------------------------------
        use({
            "nvim-treesitter/nvim-treesitter",
            config = cfg("treesitter"),
            run = ":TSUpdate",
        })

        --------------------------------------------------
        -- editing support
        --------------------------------------------------
        use({
            "lewis6991/gitsigns.nvim",
            config = cfg("gitsigns"),
        })

        use({
            "danymat/neogen",
            config = cfg("neogen"),
        })

        use({
            "windwp/nvim-autopairs",
            config = cfg("pairs"),
            event = "InsertEnter",
        })

        use({
            "hrsh7th/nvim-cmp",
            config = cfg("cmp"),
            module = "cmp",
            event = "InsertEnter",
            requires = {
                { "hrsh7th/cmp-buffer", event = "InsertEnter" },
                { "hrsh7th/cmp-emoji", event = "InsertEnter", keys = ":" },

                {
                    "petertriho/cmp-git",
                    config = function()
                        require("cmp_git").setup()
                    end,
                    requires = "nvim-lua/plenary.nvim",
                    ft = "gitcommit",
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

                { "L3MON4D3/LuaSnip", event = "InsertEnter" },
                { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
            },
        })

        --use({ "tpope/vim-obsession", cmd = "Obsess" })

        use({
            "gbprod/substitute.nvim",
            config = function()
                require("substitute").setup()
            end,
        })

        use({ "machakann/vim-swap", keys = { "g<", "g>" } })

        use({ "jbyuki/venn.nvim", cmd = "VBox" })

        --------------------------------------------------
        -- quickfix
        --------------------------------------------------
        vim.cmd("packadd! cfilter")

        use({
            "kevinhwang91/nvim-bqf",
            config = function()
                require("bqf").setup({
                    preview = {
                        border_chars = { "", "", "", "", "", "", "", "", "" },
                        win_height = 999,
                    },
                })
            end,
            ft = "qf",
        })

        use({
            "https://gitlab.com/yorickpeterse/nvim-pqf",
            config = function()
                require("pqf").setup({})
            end,
            ft = "qf",
        })

        --------------------------------------------------
        -- formatting and linting
        --------------------------------------------------
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = cfg("null_ls"),
        })

        use({
            "mcauley-penney/tidy.nvim",
            event = "BufWritePre",
        })

        --------------------------------------------------
        -- motions and textobjects
        --------------------------------------------------
        use({
            "chaoren/vim-wordmotion",
            keys = { "b", "c", "d", "k", "w", "y" },
        })

        use("wellle/targets.vim")

        --------------------------------------------------
        -- navigation
        --------------------------------------------------
        use({
            "phaazon/hop.nvim",
            branch = "v1", -- optional but strongly recommended
            config = function()
                require("hop").setup({
                    keys = "etovxqpdygfblzhckisuran",
                })
            end,
            cmd = "HopChar1",
        })

        use({
            "simrat39/symbols-outline.nvim",
            setup = function()
                vim.g.symbols_outline = {
                    auto_preview = true,
                    highlight_hovered_item = true,
                    show_guides = false,
                    width = 60,
                }
            end,
            cmd = "SymbolsOutline",
        })

        use({
            "simnalamburt/vim-mundo",
            setup = function()
                vim.g.mundo_header = 0
                vim.g.mundo_preview_bottom = 1
                vim.g.mundo_right = 1
                vim.g.mundo_mappings = {
                    ["<cr>"] = "preview",
                    e = "mode_newer",
                    n = "mode_older",
                    q = "quit",
                    ["<esc>"] = "quit",
                }
            end,
        })

        --------------------------------------------------
        -- UI
        --------------------------------------------------
        use("/home/m/files/nonwork/still_light.nvim")

        use({
            "akinsho/bufferline.nvim",
            config = cfg("bufferline"),
            event = "BufHidden",
        })

        use({
            "lukas-reineke/indent-blankline.nvim",
            config = cfg("indent_blankline"),
        })

        use({
            "norcalli/nvim-colorizer.lua",
            config = cfg("colorizer"),
            ft = { "lua", "css" },
        })

        use({
            "petertriho/nvim-scrollbar",
            config = cfg("scrollbar"),
            event = "CursorMoved",
        })

        use({
            "kyazdani42/nvim-web-devicons",
            config = function()
                require("nvim-web-devicons").set_icon({})
            end,
            module = "nvim-web-devicons",
        })

        use({ "itchyny/vim-highlighturl" })

        use({
            "rrethy/vim-illuminate",
            setup = function()
                vim.g.Illuminate_delay = 300
                vim.g.Illuminate_highlightUnderCursor = 0
            end,
            event = "CursorHold",
        })

        use({
            "lukas-reineke/virt-column.nvim",
            config = function()
                require("virt-column").setup({ char = "│" })
            end,
            event = "InsertEnter",
        })

        --------------------------------------------------
        -- filetype support
        --------------------------------------------------
        use({
            "iamcco/markdown-preview.nvim",
            run = function()
                vim.fn["mkdp#util#install"]()
            end,
            setup = function()
                vim.g.mkdp_auto_start = 1
                vim.g.mkdp_auto_close = 1
                vim.g.mkdp_browser = "firefox"
                vim.g.mkdp_page_title = "${name}.md"
                vim.g.mkdp_preview_options = {
                    disable_sync_scroll = 0,
                    disable_filename = 1,
                }
            end,
            ft = "markdown",
        })

        use({
            "akinsho/toggleterm.nvim",
            config = function()
                require("toggleterm").setup({
                    direction = "float",
                    open_mapping = [[<C-space>]],
                })
            end,
            keys = [[<C-space>]],
        })
    end,

    -- packer configuration ------------------------------
    config = {
        compile_path = compiled,
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
    vim.cmd(string.format("source %s", compiled))
    vim.g.packer_compiled_loaded = true
end
