local cmp = require("cmp")

cmp.setup({
    documentation = {
        border = "rounded",
    },

    experimental = { native_menu = true },

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "BUFFER",
                emoji = "EMOJI",
                cmp_git = "GIT",
                nvim_lsp = "LSP",
                path = "PATH",
                vsnip = "VSNIP",
            })[entry.source.name]

            return vim_item
        end,
    },

    mapping = {
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<down>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
    },

    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

    sorting = {
        comparators = {
            cmp.config.compare.recently_used,
            cmp.config.compare.exact,
            cmp.config.compare.length,
            cmp.config.compare.offset,
            cmp.config.compare.order,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.score,
        },
    },

    sources = {
        { name = "buffer", max_item_count = 5 },
        { name = "cmp_git" },
        { name = "emoji", max_item_count = 10 },
        { name = "latex_symbols" },
        { name = "nvim_lsp" },
        { name = "nvim_lua", max_item_count = 5 },
        { name = "path" },
        { name = "vsnip" },
    },
})
