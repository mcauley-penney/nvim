local cmp = require("cmp")
local border = require("jmp.ui").border

local window_opts = {
	border = border,
	max_height = 75,
	max_width = 75,
	winhighlight = table.concat({
		'Normal:NormalFloat',
		'FloatBorder:FloatBorder',
	}, ','),
}

cmp.setup({
	completion = {
		keyword_length = 2
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				buffer = "buffer",
				cmp_git = "git",
				latex_symbols = "tex",
				nvim_lsp = "lsp",
				nvim_lua = "lua",
				path = "path",
				vsnip = "vsnip",
			})[entry.source.name]

			return vim_item
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
		['<Down>'] = cmp.mapping.select_next_item(),
		['<Up>'] = cmp.mapping.select_prev_item(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
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


vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "SpecialComment" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "SpecialComment" })
