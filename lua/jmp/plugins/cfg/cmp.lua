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
