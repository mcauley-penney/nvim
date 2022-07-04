local PACKER_PATH = vim.fn.stdpath("cache") .. "/packer/packer_compiled.lua"

local function cfg(name)
    return string.format([[require 'jmp.plugins.cfg.%s']], name)
end

local plugins = {
    --------------------------------------------------
    -- testing
    --------------------------------------------------
    -- TODO: add keymaps
    -- {
    --     "ThePrimeagen/refactoring.nvim",
    --     requires = {
    --         { "nvim-lua/plenary.nvim" },
    --         { "nvim-treesitter/nvim-treesitter" },
    --     },
    -- })

    {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    },

    -- using packer.nvim
    {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup({})
        end,
    },

    --------------------------------------------------
    -- core
    --------------------------------------------------
    "wbthomason/packer.nvim",

    "lewis6991/impatient.nvim",

    "nvim-lua/plenary.nvim",

    { "dstein64/vim-startuptime", cmd = "StartupTime" },

    --------------------------------------------------
    -- LSP
    --------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        config = cfg("lspconfig"),
    },

    {
        "williamboman/nvim-lsp-installer",
        config = function()
            require("nvim-lsp-installer").setup({
                ui = {
                    icons = {
                        server_installed = "✓",
                        server_pending = "►",
                        server_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                align = {
                    bottom = false,
                },
                text = {
                    spinner = { "", "", "", "" },
                },
                timer = {
                    spinner_rate = 150,
                },
                window = {
                    relative = "editor",
                    blend = 0,
                },
            })
        end,
    },

    {
        "amrbashir/nvim-docs-view",
        config = function()
            require("docs-view").setup({
                position = "bottom",
            })
        end,
    },

    --------------------------------------------------
    -- treesitter
    --------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        config = cfg("treesitter"),
        run = ":TSUpdate",
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = "nvim-treesitter/nvim-treesitter",
    },

    --------------------------------------------------
    -- editing support
    --------------------------------------------------
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "monaqa/dial.nvim",
        config = cfg("dial"),
    },

    {
        "lewis6991/gitsigns.nvim",
        config = cfg("gitsigns"),
    },

    {
        "danymat/neogen",
        config = cfg("neogen"),
        requires = "nvim-treesitter/nvim-treesitter",
    },

    {
        "windwp/nvim-autopairs",
        config = cfg("pairs"),
    },

    -- TODO: try out coq.nvim
    {
        "hrsh7th/nvim-cmp",
        config = cfg("cmp"),
        requires = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-emoji" },

            {
                "petertriho/cmp-git",
                config = function()
                    require("cmp_git").setup()
                end,
                requires = "nvim-lua/plenary.nvim",
            },

            { "kdheepak/cmp-latex-symbols" },

            {
                "hrsh7th/cmp-nvim-lsp",
            },

            {
                "hrsh7th/cmp-nvim-lua",
            },

            {
                "hrsh7th/cmp-path",
            },

            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
        },
    },

    {
        "gbprod/substitute.nvim",
        config = function()
            require("substitute").setup()
        end,
    },

    "machakann/vim-swap",

    "jbyuki/venn.nvim",

    --------------------------------------------------
    -- quickfix
    --------------------------------------------------
    {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                indent_lines = false,
            })
        end,
    },

    --------------------------------------------------
    -- formatting and linting
    --------------------------------------------------
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = cfg("null_ls"),
    },

    {
        "mcauley-penney/tidy.nvim",
        config = function()
            require("tidy").setup()
        end,
    },

    --------------------------------------------------
    -- motions and textobjects
    --------------------------------------------------
    {
        "chaoren/vim-wordmotion",
        keys = { "b", "c", "d", "k", "w", "y" },
    },

    "wellle/targets.vim",

    --------------------------------------------------
    -- navigation
    --------------------------------------------------
    {
        "phaazon/hop.nvim",
        branch = "v1", -- optional but strongly recommended
        config = function()
            require("hop").setup({
                keys = "arstneioqwfpluy;",
            })
        end,
    },

    {
        "simrat39/symbols-outline.nvim",
        config = function()
            vim.g.symbols_outline = {
                auto_preview = true,
                highlight_hovered_item = true,
                show_guides = false,
                width = 60,
            }
        end,
    },

    {
        "simnalamburt/vim-mundo",
        config = function()
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
        cmd = "MundoToggle",
    },

    --------------------------------------------------
    -- UI
    --------------------------------------------------
    "/home/m/files/nonwork/still_light.nvim",

    {
        "akinsho/bufferline.nvim",
        config = cfg("bufferline"),
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = cfg("indent_blankline"),
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "css", "lua", "text", "vim" })
        end,
    },

    {
        "petertriho/nvim-scrollbar",
        config = cfg("scrollbar"),
    },

    {
        "kyazdani42/nvim-web-devicons",
    },

    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                direction = "float",
                open_mapping = [[<C-space>]],
            })
        end,
    },

    { "itchyny/vim-highlighturl" },

    {
        "rrethy/vim-illuminate",
        config = function()
            vim.g.Illuminate_delay = 300
            vim.g.Illuminate_highlightUnderCursor = 0
        end,
    },

    {
        "lukas-reineke/virt-column.nvim",
        config = function()
            require("virt-column").setup({ char = "│" })
        end,
    },

    --------------------------------------------------
    -- filetype support
    --------------------------------------------------
    {
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
    },
}

require("packer").startup({
    function(use)
        for _, plugin in ipairs(plugins) do
            use(plugin)
        end
    end,
    config = {
        compile_path = PACKER_PATH,
        display = {
            header_sym = "",
            open_fn = function()
                return require("packer.util").float({ border = "none" })
            end,
        },
    },
})

--load plugins from chosen location
if not vim.g.packer_compiled_loaded then
    vim.cmd("source " .. PACKER_PATH)
    vim.g.packer_compiled_loaded = true
end

return plugins
