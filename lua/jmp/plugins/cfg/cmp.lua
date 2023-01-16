local cmp = require("cmp")
local compare = cmp.config.compare
local border = require("jmp.ui").border

cmp.setup({
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

	sorting = {
		priority_weight = 1.0,
		comparators = {
			compare.offset,
			compare.exact,
			compare.score,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		},
	},

	sources = {
		{ name = "buffer", max_item_count = 10 },
		{ name = "nvim_lsp", max_item_count = 20 },
		{ name = "nvim_lua", max_item_count = 5 },
		{ name = "path" },
		{ name = "git" },
		{ name = "emoji", max_item_count = 10 },
		{ name = "digraphs" },
		{ name = "latex_symbols" },
		{ name = "vsnip" },
	},

	window = {
		documentation = {
			border = border,
			max_height = 75,
			max_width = 75,
		},
	}
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'cmdline', max_item_count = 20 },
		{ name = 'path', max_item_count = 1 },
	}),
})

vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "SpecialComment" })
