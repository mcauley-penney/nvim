local cmp = require("cmp")

cmp.setup({
    documentation = {
        border = "rounded",
    },

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                cmp_git = "[Git]",
                latex_symbols = "[LaTeX]",
                emoji = "[Emoji]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                vsnip = "[VSnip]",
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

    sources = {
        { name = "nvim_lsp" },
        { name = "buffer", max_item_count = 5 },
        { name = "nvim_lua", max_item_count = 5 },
        { name = "path" },
        { name = "cmp_git" },
        { name = "emoji", max_item_count = 10 },
        { name = "latex_symbols" },
        { name = "vsnip" },
    },

    view = {
        entries = "native",
    },
})
