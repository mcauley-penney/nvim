local float_border = require("jmp.style").border

local PACKER_PATH = vim.fn.stdpath("cache") .. "/packer/packer_compiled.lua"

-- TODO: can use pcall here to protect call?
local function cfg(name)
	return string.format([[require 'jmp.plugins.cfg.%s']], name)
end

local plugins = {
	--------------------------------------------------
	-- core
	--------------------------------------------------
	"wbthomason/packer.nvim",

	"lewis6991/impatient.nvim",

	"nvim-lua/plenary.nvim",

	{ "dstein64/vim-startuptime", cmd = "StartupTime" },

	--------------------------------------------------
	-- color scheme
	--------------------------------------------------
	"/home/m/files/nonwork/still_light.nvim",
	"/home/m/files/nonwork/daylight.nvim",

	--------------------------------------------------
	-- LSP
	--------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		config = cfg("lspconfig"),
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "→",
						package_uninstalled = "✗",
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
					fidget_decay = 250, -- how long to keep around empty fidget, in ms
					spinner_rate = 150,
					task_decay = 250,
				},
				window = {
					relative = "editor",
					blend = 0,
				},
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
		"danymat/neogen",
		config = cfg("neogen"),
		requires = "nvim-treesitter/nvim-treesitter",
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
		"windwp/nvim-autopairs",
		config = cfg("pairs"),
	},

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
	-- formatting and linting
	--------------------------------------------------
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = cfg("null_ls"),
	},

	{
		"nmac427/guess-indent.nvim",
		commit = "3c17b9a1e132d0b28a90772e3c24d226c47dbb7f",
		config = function()
			require("guess-indent").setup({
				filetype_exclude = {
					"gitcommit",
				},
			})
		end,
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
	"michaeljsmith/vim-indent-object",

	"chaoren/vim-wordmotion",

	"wellle/targets.vim",

	--------------------------------------------------
	-- navigation and searching
	--------------------------------------------------
	{
		"ibhagwan/fzf-lua",
		config = cfg("fzf"),
	},

	{
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
		config = function()
			require("hop").setup({
				case_insensitive = false,
				keys = "arstneioqwfpluy;",
				teasing = false,
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup({
				auto_close = true,
				auto_preview = false,
				autofold_depth = 1,
				auto_unfold_hover = false,
				highlight_hovered_item = false,
				show_guides = true,
				show_symbol_details = false,
			})
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

	{
		"airblade/vim-rooter",
		setup = function()
			vim.g.rooter_silent_chdir = 1
		end,
	},

	--------------------------------------------------
	-- UI
	--------------------------------------------------
	{
		"akinsho/bufferline.nvim",
		config = cfg("bufferline"),
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = cfg("indent_blankline"),
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "lua", "text", "vim" })
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		config = cfg("scrollbar"),
	},

	"kyazdani42/nvim-web-devicons",

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
		require('illuminate').configure({
			delay = 150,
			under_cursor = false,
		})
	},

	{
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup({ char = "│" })
		end,
	},

	{
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({
				ring = {
					history_length = 0,
					storage = "memory",
					sync_with_numbered_registers = false,
				},
				system_clipboard = {
					sync_with_ring = false,
				},
				highlight = {
					on_put = true,
					on_yank = false,
					timer = 200,
				},
				preserve_cursor_position = {
					enabled = true,
				},
			})
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
			local g = vim.g
			g.mkdp_auto_start = 1
			g.mkdp_auto_close = 1
			g.mkdp_browser = "firefox"
			g.mkdp_page_title = "${name}.md"
			g.mkdp_preview_options = {
				disable_sync_scroll = 0,
				disable_filename = 1,
			}
			g.mkdp_theme = "light"
		end,
		ft = "markdown",
	},

	--------------------------------------------------
	-- testing
	--------------------------------------------------
	{
		"haringsrob/nvim_context_vt",
		config = function()
			require('nvim_context_vt').setup({
				prefix = '    →',
				-- Disable display of virtual text below blocks for indentation based languages like Python
				disable_virtual_lines = true,
			})
		end
	},

	{
		"nvim-orgmode/orgmode",
		config = function()
			require('orgmode').setup_ts_grammar()
			local files = "/home/m/files/kms/gtd/"
			require('orgmode').setup({
				org_agenda_files = files .. "actions/*",
				org_default_notes_file = files .. "inbox.org",
				org_todo_keywords = { "TODO", "BLOCKED", '|', "DONE" },
			})
		end
	},

	-- {
	-- 	"ms-jpq/coq_nvim",
	-- 	config = function()
	-- 		vim.g.coq_settings = {
	-- 			auto_start = "shut-up",
	-- 			-- clients = {},
	-- 			display = {
	-- 				preview = { border = "single" },
	-- 				ghost_text = { enabled = false },
	-- 			},
	-- 			keymap = {
	-- 				recommended = false,
	-- 				pre_select = false,
	-- 			},
	-- 		}
	-- 	end,
	-- 	requires =
	-- 	{
	-- 		'ms-jpq/coq.thirdparty',
	-- 		require("coq_3p") {
	-- 			{ src = "nvimlua", short_name = "nLUA" },
	-- 			{ src = "vimtex", short_name = "vTEX" },
	-- 		}
	-- 	}
	-- },
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
				return require("packer.util").float({ border = float_border })
			end,
			prompt_border = float_border,
		},
	},
})

--load plugins from chosen location
if not vim.g.packer_compiled_loaded then
	vim.cmd.source(PACKER_PATH)
	vim.g.packer_compiled_loaded = true
end

return plugins
