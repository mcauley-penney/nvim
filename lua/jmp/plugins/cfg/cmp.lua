local cmp = require("cmp")

cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[Buffer]",
        cmp_git = "[Git]",
        latex_symbols = "[TeX]",
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
      require("luasnip").lsp_expand(args.body)
    end,
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer", max_item_count = 5 },
    { name = "nvim_lua", max_item_count = 5 },
    { name = "path" },
    { name = "git" },
    { name = "emoji", max_item_count = 10 },
    { name = "digraphs" },
    { name = "latex_symbols" },
    { name = "vsnip" },
  },

  view = {
    entries = "native",
  },
})
