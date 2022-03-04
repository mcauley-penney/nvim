--  aucmds: https://neovim.io/doc/user/autocmd.html#events

require("plugins.disable")
require("plugins.cfgs.global_cfgs")
require("impatient")

local lsp_langs = require("lsp").langs

-- putting compiled path in lua folder allows impatient to cache it
local compiled_path = "/lua/plugins/packer_compiled.lua"
compiled_path = vim.fn.stdpath("config") .. compiled_path

require("packer").startup({
    function(use)
        -- core
        use("wbthomason/packer.nvim")

        use("lewis6991/impatient.nvim")

        use({ "nvim-lua/plenary.nvim", module = "plenary" })

        -- scheme
        use("/home/m/files/nonwork/still_light.nvim")

        use({
            "kyazdani42/nvim-web-devicons",
            config = [[ require "plugins.cfgs.icons"]],
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
            config = [[ require "plugins.cfgs.lsp_installer"]],
        })

        -- treesitter
        use({
            "nvim-treesitter/nvim-treesitter",
            config = [[ require "plugins.cfgs.ts"]],
            run = ":TSUpdate",
        })

        -- formatting and linting
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = [[ require "plugins.cfgs.null_ls"]],
        })

        use({
            "mcauley-penney/tidy.nvim",
            event = "BufWritePre",
        })
        -- end core

        --luxuries
        use({
            "akinsho/bufferline.nvim",
            config = [[ require "plugins.cfgs.bufferline"]],
            event = "BufHidden",
        })

        use({
            "j-hui/fidget.nvim",
            config = [[ require "plugins.cfgs.fidget"]],
        })

        use({
            "lukas-reineke/indent-blankline.nvim",
            config = [[ require "plugins.cfgs.indent_blankline"]],
        })

        use({ "pedro757/indentInsert.nvim", module = "indentInsert" })

        use({
            "iamcco/markdown-preview.nvim",
            ft = "markdown",
            run = ":call mkdp#util#install()",
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
            "norcalli/nvim-colorizer.lua",
            config = [[ require "plugins.cfgs.colorizer"]],
            ft = { "lua", "css" },
        })

        use({
            "petertriho/nvim-scrollbar",
            config = [[ require "plugins.cfgs.scroll_bar"]],
            event = "CursorMoved",
        })

        use("wellle/targets.vim")

        use({
            "akinsho/toggleterm.nvim",
            config = [[ require "plugins.cfgs.toggleterm"]],
            keys = "<C-space>",
        })

        use({
            "folke/trouble.nvim",
            config = [[ require "plugins.cfgs.trouble"]],
            cmd = "TroubleToggle",
        })

        use({ "itchyny/vim-highlighturl" })

        use({ "rrethy/vim-illuminate", event = "CursorHold" })

        use({ "tpope/vim-obsession", event = "BufHidden" })

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

        -- Temporary?
        use({ "jbyuki/venn.nvim", cmd = "VBox" })

        use("simrat39/symbols-outline.nvim")
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
