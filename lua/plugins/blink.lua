local function get_lsp_completion_context(completion)
  local ok, source_name = pcall(
    function() return vim.lsp.get_client_by_id(completion.client_id).name end
  )
  if not ok then return nil end

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
    str = import_str:match("<(.-)>")
    if str then return "<" .. str .. ">" end

    str = import_str:match("[\"'](.-)[\"']")
    if str then return '"' .. str .. '"' end

    return nil
  end
end

return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "echasnovski/mini.snippets",
    "moyiz/blink-emoji.nvim",
  },
  opts = {
    sources = {
      default = function()
        local success, node = pcall(vim.treesitter.get_node)
        if
          success
          and node
          and vim.tbl_contains(
            { "comment", "line_comment", "block_comment" },
            node:type()
          )
        then
          return { "buffer" }
        end

        return { "lazydev", "lsp", "snippets", "path", "buffer", "emoji" }
      end,
      providers = {
        buffer = {
          name = "buffer",
          max_items = 4,
          score_offset = -2,
        },
        emoji = {
          name = "Emoji",
          module = "blink-emoji",
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
          name = "path",
          opts = {
            get_cwd = function(_) return vim.fn.getcwd() end,
          },
        },
        snippets = {
          name = "snippets",
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
      },
    },
    cmdline = {
      keymap = {
        ["<Tab>"] = { "select_and_accept" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
      },
      completion = {
        menu = { auto_show = true },
      },
    },
    snippets = { preset = "mini_snippets" },
    keymap = {
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
    },
    completion = {
      trigger = {
        show_on_backspace_after_accept = true,
        show_on_insert = true,
        show_on_trigger_character = true,
      },
      keyword = {
        range = "full",
      },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      documentation = {
        window = {
          border = "solid",
          min_width = 40,
          max_width = 70,
        },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      menu = {
        min_width = 34,
        max_height = 10,
        draw = {
          treesitter = { "lsp" },
          align_to = "cursor",
          padding = 1,
          gap = 3,
          columns = {
            { "kind_icon", gap = 0, "label" },
            { "label_description" },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx) return ctx.kind_icon end,
              highlight = function(ctx) return "BlinkCmpKind" .. ctx.kind end,
            },
            label = {
              width = {
                fill = true,
                max = 60,
              },
              text = function(ctx) return ctx.label .. ctx.label_detail end,
              highlight = function(ctx)
                local highlights = {
                  {
                    0,
                    #ctx.label,
                    group = ctx.deprecated and "BlinkCmpLabelDeprecated"
                      or "BlinkCmpLabel",
                  },
                }
                if ctx.label_detail then
                  table.insert(highlights, {
                    #ctx.label,
                    #ctx.label + #ctx.label_detail,
                    group = "BlinkCmpLabelDetail",
                  })
                end

                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(
                    highlights,
                    { idx, idx + 1, group = "BlinkCmpLabelMatch" }
                  )
                end

                return highlights
              end,
            },
            label_description = {
              text = function(ctx) return get_lsp_completion_context(ctx.item) end,
              highlight = "BlinkCmpLabelDescription",
            },
          },
        },
      },
    },
    appearance = {
      nerd_font_variant = "mono",
      kind_icons = tools.ui.kind_icons,
    },
  },
}
