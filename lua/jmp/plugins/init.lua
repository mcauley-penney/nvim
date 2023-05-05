local PACKER_PATH = vim.fn.stdpath("cache") .. "/packer/packer_compiled.lua"

local function cfg(name)
	return string.format([[require 'jmp.plugins.cfg.%s']], name)
end

local plugins = {
	--------------------------------------------------
	-- Plugin management and support
	--------------------------------------------------
	"wbthomason/packer.nvim",

	"nvim-lua/plenary.nvim",

	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({})
		end
	},

	{ "dstein64/vim-startuptime", cmd = "StartupTime" },

	--------------------------------------------------
	-- color scheme
	--------------------------------------------------
	"/home/m/files/nonwork/hl-dungeon.nvim",

	--------------------------------------------------
	-- LSP
	--------------------------------------------------
	{
		"williamboman/mason.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = '✓',
						package_pending = '┉',
						package_uninstalled = '✗',
					},
				},
			})

			require("mason-lspconfig").setup({})
		end,
	},

	{
		"onsails/lspkind.nvim",
		config = function()
			require('lspkind').init({
				symbol_map = {
					Class = ' ',
					Color = ' ',
					Constant = ' ',
					Constructor = ' ',
					Enum = ' ',
					EnumMember = ' ',
					Event = ' ',
					Field = ' ',
					File = ' ',
					Folder = ' ',
					Function = ' ',
					Interface = ' ',
					Keyword = ' ',
					Method = ' ',
					Module = ' ',
					Operator = ' ',
					Property = ' ',
					Reference = ' ',
					Snippet = ' ',
					Struct = ' ',
					Text = ' ',
					TypeParameter = ' ',
					Unit = ' ',
					Value = ' ',
					Variable = ' ',
				}
			})
		end
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

	{
		"danymat/neogen",
		config = cfg("neogen"),
		requires = "nvim-treesitter/nvim-treesitter",
	},

	{
		"echasnovski/mini.splitjoin",
		config = function()
			local MiniSplitjoin = require('mini.splitjoin')

			local pairs = {
				'%b()',
				'%b<>',
				'%b[]',
				'%b{}',
			}

			MiniSplitjoin.setup({
				detect = {
					brackets = pairs,
					separator = '[,;]',
					exclude_regions = {},
				},
				mappings = {
					toggle = 'gS',
				},
			})

			local gen_hook = MiniSplitjoin.gen_hook
			local hook_pairs = { brackets = pairs }
			local add_pair_commas = gen_hook.add_trailing_separator(hook_pairs)
			local del_pair_commas = gen_hook.del_trailing_separator(hook_pairs)
			vim.b.minisplitjoin_config = {
				split = { hooks_post = { add_pair_commas } },
				join  = { hooks_post = { del_pair_commas } },
			}
		end,
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
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				cmdline = { enabled = false },
				documentation = {
					opts = {
						position = { row = 2 },
					},
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					progress = { enabled = false },
				},
				messages = { enabled = false },
				notify = { enabled = false },
				popupmenu = { enabled = false },
				presets = {
					lsp_doc_border = true,
				},
				smart_move = {
					excluded_filetypes = {},
				},
			})
		end,
		requires = { "MunifTanjim/nui.nvim" }
	},

	{
		"hrsh7th/nvim-cmp",
		config = cfg("cmp"),
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",

			{
				"petertriho/cmp-git",
				config = function()
					require("cmp_git").setup()
				end,
				requires = "nvim-lua/plenary.nvim",
				ft = "gitcommit"
			},

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	{
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({
				highlight_substituted_text = {
					timer = 200,
				},
				range = {
					group_substituted_text = false,
					prefix = "s",
					prompt_current_text = false,
					suffix = "",
				},
			})

			local map = vim.keymap.set
			local sub = require("substitute")

			map("n", "r", sub.operator, {})
			map("n", "rr", sub.line, {})
			map("n", "R", sub.eol, {})
			map("x", "r", sub.visual, {})

			map("n", "<leader>s", require("substitute.range").operator, { noremap = true })
			map("x", "<leader>s", require("substitute.range").visual, { noremap = true })

			vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
			vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
		end,
	},

	{
		"jbyuki/venn.nvim",
		config = function()
			vim.keymap.set("n", "<S-down>", "<C-v>j:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-up>", "<C-v>k:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-left>", "<C-v>h:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-right>", "<C-v>l:VBox<CR>", { noremap = true })
			vim.keymap.set("v", "<leader>b", ":VBox<CR>", { noremap = true })
		end
	},

	{
		"machakann/vim-swap",
		config = function()
			vim.keymap.set("n", "<left>", "<Plug>(swap-prev)", {})
			vim.keymap.set("n", "<right>", "<Plug>(swap-next)", {})
		end
	},

	-- https://www.reddit.com/r/vim/comments/k10psl/how_to_convert_smart_quotes_and_other_fancy/
	"idbrii/vim-textconv",
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
		"chrisgrieser/nvim-various-textobjs",
		config = function()
			local map = vim.keymap.set
			local modes = { "o", "x" }
			-- indentation
			map(modes, "ii", function() require("various-textobjs").indentation(true, true) end)
			map(modes, "ai", function() require("various-textobjs").indentation(false, true) end)

			-- values, e.g. variable assignment
			map(modes, "iv", function() require("various-textobjs").value(true) end)
			map(modes, "av", function() require("various-textobjs").value(false) end)
		end
	},

	"wellle/targets.vim",

	{
		"chaoren/vim-wordmotion",
		setup = function()
			vim.g.wordmotion_mappings = { e = "k", ge = "gk" }
		end
	},

	--------------------------------------------------
	-- navigation and searching
	--------------------------------------------------
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				layout = {
					close_on_select = false,
					max_width = 45,
					min_width = 45,
					close_automatic_events = { "switch_buffer", "unfocus", "unsupported" },
				}
			})

			vim.keymap.set("n", "<F7>", "<cmd>AerialToggle<cr>", { silent = true })
		end
	},

	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("hop").setup({
				case_insensitive = false,
				keys = "arstneioqwfpluy;",
				teasing = false,
			})

			vim.keymap.set("n", "<F6>", "<cmd>HopChar1MW<cr>", { silent = true })
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = {
			'nvim-lua/plenary.nvim',
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "debugloop/telescope-undo.nvim" }
		},
		config = cfg("telescope")
	},

	--------------------------------------------------
	-- UI
	--------------------------------------------------
	{
		"/home/m/files/nonwork/racket-match.nvim",
		config = function()
			require("racket-match").setup({})

			vim.api.nvim_set_hl(0, "RacketMatch", { link = "Visual" })
		end
	},

	{
		'kevinhwang91/nvim-hlslens',
		config = cfg("hlslens"),
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				char = "│",
				filetype_exclude = { "fzf", "mason", "packer" },
				max_indent_increase = 1,
				show_first_indent_level = false,
				show_trailing_blankline_indent = false,
			})

			vim.api.nvim_set_hl(0, "IndentBlanklineChar", { link = "NonText" })
		end
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				filetypes = {
					"css",
					lua = { names = false },
					text = { names = false },
				}
			})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				direction = "horizontal",
				insert_mappings = false,
				open_mapping = [[<C-space>]],
				size = 50,
			})
		end,
	},

	{
		"itchyny/vim-highlighturl",
		config = function()
			vim.api.nvim_set_hl(0, "HighlightUrl", { link = "@text.uri" })
		end
	},

	{
		"rrethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				delay = 150,
				providers = {
					'regex',
				},
				under_cursor = false,
			})

			for _, type in ipairs({ "Text", "Read", "Write" }) do
				vim.api.nvim_set_hl(0, "IlluminatedWord" .. type, { link = "Cursorline" })
			end
		end
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

			vim.keymap.set("n", "p", "<Plug>(YankyPutIndentAfter)", {})
			vim.keymap.set("x", "p", "<Plug>(YankyPutIndentAfter)", {})
			vim.keymap.set("n", "P", "<Plug>(YankyPutIndentBefore)", {})
			vim.keymap.set("x", "P", "<Plug>(YankyPutIndentBefore)", {})
			vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", {})

			vim.api.nvim_set_hl(0, "YankyPut", { link = "Substitute" })
		end,
	},

	--------------------------------------------------
	-- filetype support
	--------------------------------------------------
	-- git commit
	"rhysd/committia.vim",

	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			local g = vim.g
			g.mkdp_auto_start = 0
			g.mkdp_auto_close = 0
			g.mkdp_browser = "firefox"
			g.mkdp_page_title = "${name}.md"
			g.mkdp_preview_options = {
				disable_sync_scroll = 0,
				disable_filename = 1,
			}
			g.mkdp_theme = "dark"
		end,
		ft = "markdown",
	},

	-- Org
	{
		"akinsho/org-bullets.nvim",
		config = cfg("bullets"),
		requires = "nvim-orgmode/orgmode"
	},

	{
		"nvim-orgmode/orgmode",
		config = cfg("org"),
	},

	--------------------------------------------------
	-- testing
	--------------------------------------------------
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		}
	},

	-- for vim.ui.select
	{
		'stevearc/dressing.nvim',
		config = function()
			require('dressing').setup({
				input = { enabled = false },
				select = {
					enabled = true,
					backend = {
						"telescope",
						"builtin",
					},
					telescope = require('telescope.themes').get_ivy({})
				}
			})
		end
	},

	{
		"VidocqH/lsp-lens.nvim",
		config = function()
			require("lsp-lens").setup({})
		end,
	},

	{
		"utilyre/barbecue.nvim",
		requires = { "SmiteshP/nvim-navic" },
		config = function()
			require("barbecue").setup({
				show_basename = false,
				show_dirname = false,
				symbols = {
					separator = ">",
				}
			})
		end,
	},

	{
		"dnlhc/glance.nvim",
		config = function()
			require('glance').setup({
				height = 30, -- Height of the window
				zindex = 45,
				border = {
					enable = true,
					top_char = ' ',
					bottom_char = ' ',
				}
			})

			local map = vim.keymap.set

			map('n', '<leader>D', '<cmd>Glance definitions<cr>')
			map('n', '<leader>R', '<cmd>Glance references<cr>')
			map('n', '<leader>T', '<cmd>Glance type_definitions<cr>')
			map('n', '<leader>I', '<cmd>Glance implementations<cr>')
		end,
	}
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
				return require("packer.util").float({})
			end,
		},
	},
})

--load plugins from chosen location
if not vim.g.packer_compiled_loaded then
	vim.cmd.source(PACKER_PATH)
	vim.g.packer_compiled_loaded = true
end

return plugins
