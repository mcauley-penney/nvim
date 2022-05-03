--  aucmds: https://neovim.io/doc/user/autocmd.html#events

for _, module in pairs({ "standard", "cfgs.globals" }) do
    require("plugins." .. module)
end

local lsp_langs = require("lsp").langs

-- putting compiled path in lua folder allows impatient to cache it
local compiled_path = "/lua/plugins/packer_compiled.lua"
compiled_path = vim.fn.stdpath("config") .. compiled_path

require("packer").startup({
    function(use)
        --------------------------------------------------
        -- testing
        --------------------------------------------------
        use({
            "kyazdani42/nvim-tree.lua",
            config = function()
                require("nvim-tree").setup({})
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
            config = [[require "plugins.cfgs.lsp_config"]],
        })

        use({
            "williamboman/nvim-lsp-installer",
            config = require("nvim-lsp-installer").setup({
                ui = {
                    icons = {
                        server_installed = "✓",
                        server_pending = "─►",
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
            config = [[ require "plugins.cfgs.ts"]],
            run = ":TSUpdate",
        })

        --------------------------------------------------
        -- editing support
        --------------------------------------------------
        use({
            "lewis6991/gitsigns.nvim",
            config = [[ require "plugins.cfgs.gitsigns"]],
        })

        use({
            "danymat/neogen",
            config = [[require "plugins.cfgs.neogen"]],
        })

        use({
            "windwp/nvim-autopairs",
            config = [[ require "plugins.cfgs.pairs"]],
            event = "InsertEnter",
        })

        use({
            "hrsh7th/nvim-cmp",
            config = [[ require "plugins.cfgs.cmp"]],
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

        use({ "tpope/vim-obsession", cmd = "Obsess" })

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
            config = [[ require "plugins.cfgs.null_ls"]],
        })

        use({
            "mfussenegger/nvim-lint",
            config = function()
                require("lint").linters_by_ft = {
                    c = { "flawfinder" },
                    python = { "pydocstyle", "pylint" },
                }
            end,
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
                -- you can configure Hop the way you like here; see :h hop-config
                require("hop").setup({
                    keys = "etovxqpdygfblzhckisuran",
                })
            end,
            cmd = "HopChar1",
        })

        use({ "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" })

        use({ "simnalamburt/vim-mundo", cmd = "MundoToggle" })

        --------------------------------------------------
        -- UI
        --------------------------------------------------
        use("/home/m/files/nonwork/still_light.nvim")

        use({
            "akinsho/bufferline.nvim",
            config = [[ require "plugins.cfgs.bufferline"]],
            event = "BufHidden",
            -- TODO: update when things are more stable
            tag = "v1.*",
        })

        use({
            "lukas-reineke/indent-blankline.nvim",
            config = [[ require "plugins.cfgs.indent_blankline"]],
        })

        use({
            "norcalli/nvim-colorizer.lua",
            config = [[ require "plugins.cfgs.colorizer"]],
            ft = { "lua", "css" },
        })

        use({
            "petertriho/nvim-scrollbar",
            config = [[ require "plugins.cfgs.scroll_bar"]],
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

        use({ "rrethy/vim-illuminate", event = "CursorHold" })

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
            ft = "markdown",
            run = ":call mkdp#util#install()",
        })

        use({
            "nvim-orgmode/orgmode",
            config = function()
                require("orgmode").setup_ts_grammar()
                require("orgmode").setup({
                    org_agenda_files = "~/files/org/agenda/*",
                    org_default_notes_file = "~/files/org/notes/*",
                })
            end,
        })

        use({
            "akinsho/toggleterm.nvim",
            config = [[ require "plugins.cfgs.toggleterm"]],
            keys = "<C-space>",
        })
    end,

    -- packer configuration --------------------------------------------------
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
