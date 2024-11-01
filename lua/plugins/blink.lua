--  local function get_lsp_completion_context(completion)
--    local ok, source_name = pcall(function()
--      return vim.lsp.get_client_by_id(completion.client_id).name
--    end)
--
--    if not ok then
--      return nil
--    end
--
--    if source_name == "ts_ls" then
--      return completion.detail
--    elseif source_name == "pyright" and completion.labelDetails ~= nil then
--      return completion.labelDetails.description
--    elseif source_name == "texlab" then
--      return completion.detail
--    elseif source_name == "clangd" then
--      local doc = completion.documentation
--      if doc == nil then return end
--
--      local import_str = doc.value
--      import_str = import_str:gsub("[\n]+", "")
--
--      local str
--      str = import_str:match('<(.-)>')
--      if str then
--        return '<' .. str .. '>'
--      end
--
--      str = import_str:match('["\'](.-)["\']')
--      if str then
--        return '"' .. str .. '"'
--      end
--
--      return nil
--    end
--  end

return {
  --  "saghen/blink.cmp",
  --  event = "BufReadPre",
  --  version = "v0.*", -- REQUIRED release tag to download pre-built binaries

  --  ---@module "blink.cmp"
  --  ---@type blink.cmp.Config
  --  opts = {
  --    sources = {
  --      providers = {
  --        { "blink.cmp.sources.lsp",      name = "LSP" },
  --        { "blink.cmp.sources.snippets", name = "Snippets", score_offset = -1 },
  --        {
  --          "blink.cmp.sources.path",
  --          name = "Path",
  --          score_offset = 3,
  --          opts = { get_cwd = vim.uv.cwd },
  --        },
  --        {
  --          "blink.cmp.sources.buffer",
  --          name = "Buffer",
  --          keyword_length = 3,
  --          fallback_for = { "LSP" }, -- PENDING https://github.com/Saghen/blink.cmp/issues/122
  --        },
  --      },
  --    },
  --    highlight = { use_nvim_cmp_as_default = true },
  --    keymap = {
  --      accept = "<Tab>",
  --      select_next = { "<C-n>" },
  --      select_prev = { "<C-p>" },
  --      scroll_documentation_down = "<PageDown>",
  --      scroll_documentation_up = "<PageUp>",
  --    },
  --    accept = {
  --      enabled = true
  --    },
  --    nerd_font_variant = "mono",
  --    windows = {
  --      documentation = {
  --        min_width = 15,
  --        max_width = 50,
  --        max_height = 15,
  --        border = tools.ui.borders.thin,
  --        auto_show = true,
  --        auto_show_delay_ms = 250,
  --      },
  --      autocomplete = {
  --        min_width = 20,
  --        max_height = 10,
  --        border = tools.ui.borders.none,
  --        selection = "preselect",
  --        cycle = { from_top = false },
  --        draw = function(ctx)
  --          -- differentiate snippets from LSPs, the user, and emmet
  --          local icon, cmp_item, source = ctx.kind_icon, ctx.item, ctx.item.source


  --          local cmp_ctx
  --          if source == "LSP" then
  --            cmp_ctx = get_lsp_completion_context(cmp_item)

  --            if cmp_ctx == nil then
  --              cmp_ctx = ""
  --            end
  --          end

  --          return {
  --            { " " },
  --            {
  --              " " .. ctx.item.label .. " ",
  --              fill = true,
  --              hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
  --              max_width = 45,
  --            },
  --            { cmp_ctx },
  --            { " " },
  --          }
  --        end,
  --      },
  --    },
  --    kind_icons = {
  --      Text = "󰦨",
  --      Method = "󰊕",
  --      Function = "󰊕",
  --      Constructor = "",
  --      Field = "󰇽",
  --      Variable = "󰂡",
  --      Class = "⬟",
  --      Interface = "",
  --      Module = "",
  --      Property = "󰜢",
  --      Unit = "",
  --      Value = "󰎠",
  --      Enum = "",
  --      Keyword = "󰌋",
  --      Snippet = "󰒕",
  --      Color = "󰏘",
  --      Reference = "",
  --      File = "󰉋",
  --      Folder = "󰉋",
  --      EnumMember = "",
  --      Constant = "󰏿",
  --      Struct = "",
  --      Event = "",
  --      Operator = "󰆕",
  --      TypeParameter = "󰅲",
  --    },
  --  },
}
