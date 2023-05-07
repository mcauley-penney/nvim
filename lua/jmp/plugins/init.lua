-- TODO: need a undotree
-- https://github.com/debugloop/telescope-undo.nvim
-- https://github.com/mcauley-penney/nvim/blob/8621b4cf40a0828cb495a862dcb192a9854d620f/lua/jmp/plugins/init.lua#L235

return {
	--------------------------------------------------
	-- Plugin management and support
	--------------------------------------------------
	"nvim-lua/plenary.nvim",

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime"
	},

	--------------------------------------------------
	-- color scheme
	--------------------------------------------------
	{
		dir = "/home/m/files/nonwork/hl-dungeon.nvim",
		init = function()
			vim.cmd.colorscheme("hl-dungeon")
		end
	},

	--------------------------------------------------
	-- LSP
	--------------------------------------------------
	"neovim/nvim-lspconfig",

	{
		"folke/neodev.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		ft = "lua",
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		dependencies = {
			"neovim/nvim-lspconfig"
		},
		opts = {
			ui = {
				border = "single",
				height = 0.8,
				icons = {
					package_installed = "✓",
					package_pending = "→",
					package_uninstalled = "✗",
				},
			}
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({})
		end
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
		end,
		dependencies = {
			"neovim/nvim-lspconfig",
		}
	},

	-- requires setting up cmps capabilities
	-- https://github.com/j-hui/fidget.nvim/issues/107
	{
		"j-hui/fidget.nvim",
		config = {
			align = { bottom = false },
			text = { spinner = { "", "", "", "" } },
			timer = {
				fidget_decay = 250, -- how long to keep around empty fidget, in ms
				spinner_rate = 150,
				task_decay = 250,
			},
			window = {
				relative = "editor",
				blend = 0,
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		init = function()
			vim.api.nvim_set_hl(0, "FidgetTask", { link = "NonText" })
			vim.api.nvim_set_hl(0, "FidgetTitle", { link = "Statement" })
		end
	},

	--------------------------------------------------
	-- treesitter
	--------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					--  "comment",
					"cpp",
					"diff",
					"gitcommit",
					"html",
					"http",
					"javascript",
					"json",
					"latex",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"org",
					"python",
					"regex",
					"vimdoc",
				},
				-- Install languages synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- List of parsers to ignore installing
				ignore_install = {},
				highlight = {
					-- Setting this to true will run `:h syntax` and tree-sitter at the
					-- same time. Set this to `true` if you depend on 'syntax' being
					-- enabled (like for indentation). Using this option may slow down your
					-- editor, and you may see some duplicate highlights. Instead of true
					-- it can also be a list of languages
					enable = true,
					-- ORG: Required for spellcheck, some LaTex highlights and code
					-- block highlights that do not have ts grammar
					additional_vim_regex_highlighting = { 'org' },
				},
				textobjects = {
					lookahead = true,
					select = {
						enable = true,
						keymaps = {
							["iC"] = "@call.inner",
							["aC"] = "@call.outer",
							["ic"] = "@conditional.inner",
							["ac"] = "@conditional.outer",
							["if"] = "@function.inner",
							["af"] = "@function.outer",
							["il"] = "@loop.inner",
							["al"] = "@loop.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@function.outer",
						},
						swap_previous = {
							["<leader>A"] = "@function.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					}
				},
			})
		end
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = {
			enabled = true,
			languages = {
				lua = {
					template = {
						annotation_convention = "ldoc",
					},
				},
				python = {
					template = {
						annotation_convention = "google_docstrings",
					},
				},
			},
		},
		init = function()
			vim.keymap.set("n", "<leader>id", require('neogen').generate, {})
		end
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
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	--------------------------------------------------
	-- editing support
	--------------------------------------------------
	{
		"numToStr/Comment.nvim",
		config = true
	},

	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			local dial = require("dial.map")
			local expr = { expr = true, remap = false }
			local map = vim.keymap.set

			map("n", "<C-a>", dial.inc_normal, expr)
			map("n", "<C-x>", dial.dec_normal, expr)
			map("v", "<C-a>", dial.inc_visual, expr)
			map("v", "<C-x>", dial.dec_visual, expr)
			map("v", "g<C-a>", dial.inc_gvisual, expr)
			map("v", "g<C-x>", dial.dec_gvisual, expr)

			require("dial.config").augends:register_group({
				-- default augends used when no group name is specified
				default = {
					augend.constant.alias.alpha,
					augend.constant.alias.Alpha,
					augend.constant.alias.bool,
					augend.integer.alias.decimal_int,
					augend.date.alias["%Y-%m-%d"], -- iso 8601
					augend.date.alias["%Y/%m/%d"], -- iso 8601
					augend.date.alias["%m/%d/%y"],
					augend.date.alias["%m/%d"],

					augend.constant.new({
						elements = { "and", "or" },
						word = true,
						cyclic = true,
					}),

					augend.constant.new({
						elements = { "True", "False" },
						word = true,
						cyclic = true,
					}),
				},
			})
		end
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local ui = require("jmp.ui.utils")
			local set_hl = vim.api.nvim_set_hl

			local gra = "Nontext"
			local grn = "DiagnosticOk"
			local red = "DiagnosticError"
			local ylw = "DiagnosticWarn"
			local sym = '┃'

			local sign_tbl = {}
			local dim_hl, fg
			for grp, hl in pairs({
				Add = grn,
				Change = ylw,
				Changedelete = ylw,
				Delete = red,
				Topdelete = red,
				Untracked = gra,
			}) do
				fg = ui.get_hl_grp_rgb(hl, "fg")
				dim_hl = ui.shade_color(fg, -25)
				set_hl(0, "GitSigns" .. grp, { fg = dim_hl })

				sign_tbl[string.lower(grp)] = { text = sym }
			end


			local diffadd_bg = ui.get_hl_grp_rgb("DiffAdd", "bg")
			local diffrm_bg = ui.get_hl_grp_rgb("DiffDelete", "bg")

			local diffadd_lighter = ui.shade_color(diffadd_bg, 75)
			local diffrm_lighter = ui.shade_color(diffrm_bg, 75)

			set_hl(0, "GitSignsAddInline", { link = "DiffAdd" })
			set_hl(0, "GitSignsAddLnInline", { fg = "fg", bg = diffadd_lighter })
			set_hl(0, "GitSignsChangeInline", { link = "DiffText" })
			set_hl(0, "GitSignsChangeLnInline", { link = "DiffChange" })
			set_hl(0, "GitSignsDeleteInline", { link = "DiffDelete" })
			set_hl(0, "GitSignsDeleteLnInline", { fg = "fg", bg = diffrm_lighter })

			require("gitsigns").setup({
				-- see https://github.com/akinsho/dotfiles/blob/83040e0d929bcdc56de82cfd49a0b9110603ceee/.config/nvim/plugin/statuscolumn.lua#L58-L72
				_extmark_signs = false,
				_inline2 = true,
				_signs_staged_enable = false,
				_threaded_diff = true,
				preview_config = {
					border = "single",
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1
				},
				signs = sign_tbl,
				signcolumn = true,
				update_debounce = 500,
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					map('n', '<leader>gb', function() gs.blame_line({ full = true }) end)
					map('n', '<leader>gd', gs.diffthis)
					map('n', '<leader>gD', function() gs.diffthis('~') end)
					map("n", "<leader>gt", gs.toggle_signs)
					map("n", "<leader>hp", gs.preview_hunk_inline)
					map("n", "<leader>hu", gs.undo_stage_hunk)

					map({ "n", "v" }, "<leader>hs", ':Gitsigns stage_hunk<CR>')
					map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')

					for map_str, fn in pairs({
						["]h"] = gs.next_hunk,
						["[h"] = gs.prev_hunk
					}) do
						map('n', map_str, function()
							if vim.wo.diff then return map_str end
							vim.schedule(function() fn() end)
							return '<Ignore>'
						end, { expr = true })
					end
				end
			})
		end
	},

	"MunifTanjim/nui.nvim",

	{
		"folke/noice.nvim",
		config = {
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
		},
		dependencies = { "MunifTanjim/nui.nvim" }
	},

	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")

			local window_opts = {
				border = "single",
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
			---@param completion lsp.CompletionItem
			---@param source cmp.Source
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
					--- @param entry cmp.Entry
					--- @param vim_item vim.CompletedItem
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
					['<Down>'] = cmp.mapping.select_next_item(),
					['<Up>'] = cmp.mapping.select_prev_item(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				},
				matching = {
					disallow_fuzzy_matching = true,
					disallow_fullfuzzy_matching = true,
					disallow_partial_fuzzy_matching = true,
					disallow_partial_matching = false,
					disallow_prefix_unmatching = false,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp",     max_item_count = 20 },
					{ name = "nvim_lua",     max_item_count = 5 },
					{ name = "buffer",       max_item_count = 5 },
					{ name = 'orgmode' },
					{ name = "path" },
					{ name = "git" },
					{ name = "latex_symbols" },
					{ name = "vsnip" },
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


			local set_hl = vim.api.nvim_set_hl

			set_hl(0, "CmpItemAbbr", { fg = "fg" })

			set_hl(0, "CmpItemAbbrMatch", { link = "@text.uri" })
			set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpItemAbbrMatch" })

			set_hl(0, "CmpItemKindVariable", { fg = "fg" })
			set_hl(0, "CmpItemKindFunction", { link = "Function" })
			set_hl(0, "CmpItemKindKeyword", { link = "Keyword" })

			for k, v in pairs({
				CmpItemAbbrMatch      = "@text.uri",
				CmpItemAbbrMatchFuzzy = "CmpItemAbbrMatch",
				CmpItemKindInterface  = "CmpItemKindVariable",
				CmpItemKindText       = "CmpItemKindVariable",
				CmpItemKindMethod     = "CmpItemKindFunction",
				CmpItemKindProperty   = "CmpItemKindKeyword",
				CmpItemKindUnit       = "CmpItemKindKeyword",
			}) do
				set_hl(0, k, { link = v })
			end
		end,
		dependencies = {
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
		config = {
			highlight_substituted_text = {
				timer = 200,
			},
			range = {
				group_substituted_text = false,
				prefix = "s",
				prompt_current_text = false,
				suffix = "",
			},
		},
		init = function()
			vim.keymap.set("n", "r", require("substitute").operator, {})
			vim.keymap.set("n", "rr", require("substitute").line, {})
			vim.keymap.set("n", "R", require("substitute").eol, {})
			vim.keymap.set("x", "r", require("substitute").visual, {})

			vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
			vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
		end,
	},

	{
		"jbyuki/venn.nvim",
		init = function()
			vim.keymap.set("n", "<S-down>", "<C-v>j:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-up>", "<C-v>k:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-left>", "<C-v>h:VBox<CR>", { noremap = true })
			vim.keymap.set("n", "<S-right>", "<C-v>l:VBox<CR>", { noremap = true })
			vim.keymap.set("v", "<leader>b", ":VBox<CR>", { noremap = true })
		end
	},

	{
		"machakann/vim-swap",
		init = function()
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
		config = function()
			local null_ls = require("null-ls")
			local builtins = null_ls.builtins

			null_ls.setup({
				debounce = 300,
				on_attach = require("jmp.lsp.on_attach"),
				sources = {
					-- json
					builtins.formatting.fixjson,

					-- python
					builtins.diagnostics.pydocstyle,
					builtins.formatting.black,

					-- sh
					builtins.diagnostics.shellcheck,

					-- GitHub actions/yaml
					builtins.diagnostics.actionlint,
				},
			})
		end
	},

	{
		"mcauley-penney/tidy.nvim",
		config = true
	},

	--------------------------------------------------
	-- motions and textobjects
	--------------------------------------------------
	{
		"chrisgrieser/nvim-various-textobjs",
		init = function()
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
		init = function()
			vim.g.wordmotion_mappings = { e = "k", ge = "gk" }
		end
	},

	--------------------------------------------------
	-- navigation and searching
	--------------------------------------------------
	{
		"stevearc/aerial.nvim",
		config = {
			layout = {
				close_on_select = false,
				max_width = 45,
				min_width = 45,
				close_automatic_events = { "switch_buffer", "unfocus", "unsupported" },
			}
		},
		init = function()
			vim.keymap.set("n", "<F7>", "<cmd>AerialToggle<cr>", { silent = true })
		end
	},

	{
		"phaazon/hop.nvim",

		branch = "v2", -- optional but strongly recommended
		config = {
			case_insensitive = false,
			keys = "arstneioqwfpluy;",
			teasing = false,
		},

		init = function()
			vim.keymap.set("n", "'", "<cmd>HopChar1MW<cr>", { silent = true })
		end
	},

	{
		"nvim-telescope/telescope.nvim",

		tag = "0.1.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
		},
		config = {
			defaults = {
				border = true,
				borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
				file_ignore_patterns = {
					"%.jpg",
					"%.jpeg",
					"%.png",
					"%.otf",
					"%.ttf",
					"%.DS_Store",
					"^.git*",
					"^node_modules/",
					"^site-packages/",
					"^.yarn/",
				},
				layout_strategy = "bottom_pane",
				layout_config = {
					prompt_position = "top",
					height = 30,
					width = 1,
				},
				sorting_strategy = "ascending",
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				--  undo = {
				--  	diff_context_lines = 10,
				--  	mappings = {
				--  		i = {
				--  			["<cr>"] = require("telescope-undo.actions").restore,
				--  			["<C-cr>"] = require("telescope-undo.actions").yank_additions,
				--  			["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
				--  		},
				--  	},
				--  },
			},
			pickers = {
				buffers = {
					ignore_current_buffer = true,
					show_all_buffers = true,
					sort_lastused = true,
					sort_mru = true,
					mappings = {
						i = {
							["<c-d>"] = "delete_buffer",
						},
						n = {
							["<c-d>"] = "delete_buffer",
						}
					}
				},
				find_files = {
					hidden = true
				},
			}
		},

		init = function()
			require("telescope").load_extension("fzf")

			local builtin = require("telescope.builtin")

			vim.api.nvim_create_autocmd("QuickFixCmdPost", {
				group = vim.api.nvim_create_augroup("Telescope", { clear = true }),
				callback = function()
					builtin.quickfix()
				end
			})

			vim.api.nvim_create_user_command("Highlights", function()
				builtin.highlights()
			end, {})

			vim.api.nvim_create_user_command("Keymaps", function()
				builtin.keymaps()
			end, {})

			vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "StatusLine" })

			vim.keymap.set("n", "<C-t>", builtin.find_files, { silent = true })
			vim.keymap.set("n", "<C-q>", builtin.quickfix, { silent = true })
			vim.keymap.set("n", "\\", builtin.buffers, { silent = true })
			vim.keymap.set("n", "<C-f>", builtin.live_grep, { silent = true })

			vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { silent = true })

			vim.keymap.set("n", "<C-t>", builtin.find_files, { silent = true })
			vim.keymap.set("n", "\\", builtin.buffers, { silent = true })
		end
	},

	--------------------------------------------------
	-- UI
	--------------------------------------------------
	{
		'kevinhwang91/nvim-hlslens',
		config = function()
			local function lens(render, pos_list, nearest, wkg_i, relIdx)
				local hl = "Statusline"
				local sfw = vim.v.searchforward == 1
				local indicator, text, chunks
				local abs_rel_idx = math.abs(relIdx)

				if abs_rel_idx > 1 then
					indicator = (' %d%s'):format(abs_rel_idx, sfw ~= (relIdx > 1) and 'N' or 'n')
				else
					indicator = ''
				end

				local lnum, col = unpack(pos_list[wkg_i])
				local total = #pos_list
				local cur_ratio = (' [%d/%d] '):format(wkg_i, total)

				if nearest then
					text = cur_ratio
					chunks = { { ' ', 'Ignore' }, { text, hl } }
				else
					text = ('%s%s'):format(indicator, cur_ratio)
				end

				chunks = { { ' ', 'Ignore' }, { text, hl } }

				render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
			end


			require('hlslens').setup({
				calm_down = true,
				override_lens = lens
			})

			local map = vim.api.nvim_set_keymap
			local kopts = { noremap = true, silent = true }

			map('n', 'j',
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts)
			map('n', 'J',
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts)
			map('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			map('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			map('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			map('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

			map('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
		end
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				char = "├",
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
		config = {
			filetypes = {
				"css",
				lua = { names = false },
				text = { names = false },
			}
		}
	},

	"nvim-tree/nvim-web-devicons",

	{
		dir = "/home/m/files/nonwork/racket-match.nvim",
		config = true,
		init = function()
			vim.api.nvim_set_hl(0, "RacketMatch", { link = "Visual" })
		end
	},

	{
		"akinsho/toggleterm.nvim",
		config = {
			direction = "horizontal",
			insert_mappings = false,
			open_mapping = [[<C-space>]],
			size = 50,
		}
	},

	{
		"itchyny/vim-highlighturl",
		init = function()
			vim.api.nvim_set_hl(0, "HighlightUrl", { link = "@text.uri" })
		end
	},

	{
		"rrethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				delay = 150,
				providers = { 'regex' },
				under_cursor = false,
			})
		end,

		init = function()
			for _, type in ipairs({ "Text", "Read", "Write" }) do
				vim.api.nvim_set_hl(0, "IlluminatedWord" .. type, { link = "CursorLine" })
			end
		end
	},

	{
		"lukas-reineke/virt-column.nvim",
		config = { char = "│" },
		init = function()
			vim.api.nvim_set_hl(0, "VirtColumn", { link = "VertSplit" })
		end
	},

	{
		"gbprod/yanky.nvim",
		config = {
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
		},

		init = function()
			vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
			vim.keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
			vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
			vim.keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
		end,
	},

	--------------------------------------------------
	-- filetype support
	--------------------------------------------------
	-- git commit
	"rhysd/committia.vim",

	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			local g = vim.g
			g.mkdp_auto_start = 0
			g.mkdp_auto_close = 1
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

	{
		"nvim-orgmode/orgmode",
		config = function()
			local files = "/home/m/files/kms/gtd/"
			local ui = require("jmp.ui")
			local icons = ui["no_hl_icons"]


			require('orgmode').setup({
				org_agenda_files = files .. "agenda/*",
				org_archive_location = files .. "archive.org",
				org_capture_templates = {
					t = { description = 'Task', template = '* TODO %?\n  %U' }
				},
				org_default_notes_file = files .. "inbox.org",
				org_ellipsis = table.concat({ " ", icons["fold"], " " }),
				org_indent = "noindent",
				org_todo_keywords = { "TODO(t)", "BLOCKED", "WAITING", '|', "DONE" },

				win_split_mode = "below 30split"
			})

			-- TODO: turn off underlining for TSHeadlines
			vim.api.nvim_set_hl(0, "OrgDONE", { link = "DiagnosticOk" })
			vim.api.nvim_set_hl(0, "OrgDONE_builtin", { link = "DiagnosticOk" })
			vim.api.nvim_set_hl(0, "OrgTSCheckbox", { link = "Normal" })

			local grp = vim.api.nvim_create_augroup("org", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = "org",
				callback = function()
					vim.api.nvim_win_set_option(0, "foldenable", false)
					vim.api.nvim_win_set_option(0, "conceallevel", 2)
				end
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = "orgagenda",
				command = "set textwidth=0"
			})

			require('orgmode').setup_ts_grammar()
		end
	},

	{
		"akinsho/org-bullets.nvim",
		config = {
			concealcursor = true,
			symbols = {
				headlines = { "→" },
				checkboxes = {
					half = { "-", "OrgTSCheckboxHalfChecked" },
					done = { "✔", "OrgDone" },
					todo = { "✘", "OrgTODO" },
				},
			}
		},
		dependencies = "nvim-orgmode/orgmode"
	},

	--------------------------------------------------
	-- testing
	--------------------------------------------------

	{
		'stevearc/dressing.nvim',
		config = {
			input = { enabled = false },
			select = {
				enabled = true,
				backend = {
					"telescope",
					"builtin",
				},
				--  telescope = require("telescope.themes").get_ivy({})
			}
		},
		dependencies = "nvim-telescope/telescope.nvim"
	},

	{
		"VidocqH/lsp-lens.nvim",
		config = true
	},

	{
		"utilyre/barbecue.nvim",
		config = {
			show_basename = false,
			show_dirname = false,
			symbols = {
				separator = ">",
			}
		},
		dependencies = { "SmiteshP/nvim-navic" },
	}
}
