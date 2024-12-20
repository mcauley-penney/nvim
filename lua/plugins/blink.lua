local function get_lsp_completion_context(completion)
  local ok, source_name = pcall(function()
    return vim.lsp.get_client_by_id(completion.client_id).name
  end)

  if not ok then
    return nil
  end

  if source_name == "ts_ls" then
    return completion.detail
  elseif source_name == "pyright" and completion.labelDetails ~= nil then
    return completion.labelDetails.description
  elseif source_name == "texlab" then
    return completion.detail
  elseif source_name == "clangd" then
    local doc = completion.documentation
    if doc == nil then return end

    local import_str = doc.value
    import_str = import_str:gsub("[\n]+", "")

    local str
    str = import_str:match('<(.-)>')
    if str then
      return '<' .. str .. '>'
    end

    str = import_str:match('["\'](.-)["\']')
    if str then
      return '"' .. str .. '"'
    end

    return nil
  end
end

return {
  "saghen/blink.cmp",
  version = 'v0.*',
  opts = {
    sources = {
      default = { "lsp", "path", "luasnip", "lazydev", "buffer" },
      providers = {
        buffer = {
          name = "buffer",
          max_items = 4,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          fallbacks = { "LSP" },
        },
        lsp = {
          name = "LSP",
        },
        path = {
          name = "Path",
          opts = { get_cwd = vim.uv.cwd },
        },
        snippets = {
          name = "Snippets",
        },
      },
    },
    keymap = { preset = 'super-tab' },
    completion = {
      list = {
        selection = "auto_insert",
        cycle = { from_top = false },
        max_items = 50,
      },
      documentation = {
        window = {
          min_width = 15,
          max_width = 50,
          max_height = 15,
          border = tools.ui.borders.thin,
        },
        auto_show = true,
        auto_show_delay_ms = 250,
      },
      ghost_text = {
        enabled = false,
      },
      menu = {
        min_width = 42,
        max_height = 10,
        border = tools.ui.borders.none,
        draw = {
          padding = 2,
          gap = 3,
          columns = { { 'kind_icon', gap = 2, 'label' }, { 'label_description' } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
              highlight = function(ctx) return 'BlinkCmpKind' .. ctx.kind end,
            },
            label = {
              width = {
                fill = true,
                max = 60,
              },
              text = function(ctx) return ctx.label .. ctx.label_detail end,
              highlight = function(ctx)
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                }
                if ctx.label_detail then
                  table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                end

                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end

                return highlights
              end,
            },
            label_description = {
              width = { fill = true },
              text = function(ctx) return get_lsp_completion_context(ctx.item) end,
              highlight = 'BlinkCmpLabelDescription',
            }
          },
        },
      },
    },
    appearance = {
      nerd_font_variant = "mono",
      kind_icons = {
        Text = "󰦨 ",
        Method = '󰆦 ',
        Function = '󰆦 ',
        Constructor = '󰆦 ',
        Field = ' ',
        Variable = ' ',
        Class = ' ',
        Interface = ' ',
        Module = ' ',
        Property = ' ',
        Unit = ' ',
        Value = ' ',
        Enum = ' ',
        Keyword = ' ',
        Snippet = ' ',
        Color = ' ',
        File = ' ',
        Reference = ' ',
        Folder = ' ',
        EnumMember = ' ',
        Constant = ' ',
        Struct = ' ',
        Event = '',
        Operator = ' ',
        TypeParameter = ' ',
      },
    }
  },
}
