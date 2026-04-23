local GH = function(repo) return "https://github.com/" .. repo end

vim.g.wordmotion_mappings = { e = "k", ge = "gk" }

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if
      name == "nvim-treesitter" and (kind == "install" or kind == "update")
    then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

local function selective_load(plug)
  if (plug.spec.data or {}).defer then return end
  vim.cmd.packadd(plug.spec.name)
end

vim.pack.add({
  GH("mcauley-penney/techbase.nvim"),
  { src = GH("mcauley-penney/aerial.nvim"), version = "fix-md-header-icons" },
  GH("LunarVim/bigfile.nvim"),
  GH("echasnovski/mini.snippets"),
  GH("folke/lazydev.nvim"),
  GH("moyiz/blink-emoji.nvim"),
  { src = GH("saghen/blink.cmp"), version = vim.version.range("1.x") },
  GH("rhysd/committia.vim"),
  GH("stevearc/conform.nvim"),
  GH("Bekaboo/dropbar.nvim"),
  GH("folke/edgy.nvim"),
  GH("j-hui/fidget.nvim"),
  GH("Wansmer/symbol-usage.nvim"),
  GH("ibhagwan/fzf-lua"),
  GH("lewis6991/gitsigns.nvim"),
  GH("itchyny/vim-highlighturl"),
  GH("kevinhwang91/nvim-hlslens"),
  GH("echasnovski/mini.icons"),
  GH("rrethy/vim-illuminate"),
  GH("rareitems/hl_match_area.nvim"),
  GH("neovim/nvim-lspconfig"),
  GH("mason-org/mason.nvim"),
  { src = GH("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = GH("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  GH("kevinhwang91/promise-async"),
  GH("kevinhwang91/nvim-ufo"),
  GH("luukvbaal/statuscol.nvim"),
  GH("gbprod/substitute.nvim"),
  GH("machakann/vim-swap"),
  GH("wellle/targets.vim"),
  { src = GH("mcauley-penney/tidy.nvim"), version = "only-modified" },
  GH("rachartier/tiny-glimmer.nvim"),
  GH("danymat/neogen"),
  GH("echasnovski/mini.splitjoin"),
  GH("chrisgrieser/nvim-various-textobjs"),
  GH("lukas-reineke/virt-column.nvim"),
  GH("chaoren/vim-wordmotion"),
  { src = GH("windwp/nvim-autopairs"), data = { defer = true } },
  { src = GH("monaqa/dial.nvim"), data = { defer = true } },
  {
    src = GH("MeanderingProgrammer/render-markdown.nvim"),
    data = { defer = true },
  },
  {
    src = GH("mcauley-penney/visual-whitespace.nvim"),
    data = { defer = true },
  },
  { src = GH("folke/which-key.nvim"), data = { defer = true } },
}, { load = selective_load })

pcall(vim.cmd.colorscheme, "techbase")

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
    if doc == nil then return nil end

    local import_str = doc.value:gsub("[\n]+", "")

    local str = import_str:match("<(.-)>")
    if str then return "<" .. str .. ">" end

    str = import_str:match("[\"'](.-)[\"']")
    if str then return '"' .. str .. '"' end

    return nil
  end
end

require("aerial").setup({
  close_automatic_events = {
    "unfocus",
    "switch_buffer",
  },
  show_guides = false,
  guides = {
    nested_top = " │ ",
    mid_item = " ├─",
    last_item = " └─",
    whitespace = "    ",
  },
  layout = {
    placement = "window",
    close_on_select = false,
    max_width = 45,
    min_width = 25,
  },
  ignore = {
    buftypes = {},
  },
  icons = tools.ui.kind_icons,
  open_automatic = function()
    local aerial = require("aerial")
    return vim.api.nvim_win_get_width(0) > 80 and not aerial.was_closed()
  end,
})
vim.keymap.set("n", "<F18>", "<cmd>AerialToggle<cr>", { silent = true })

require("bigfile").setup({
  features = {
    "illuminate",
    "treesitter",
    "syntax",
    "matchparen",
    "vimopts",
  },
})

require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_lang(),
  },
  mappings = {
    stop = "<C-c>",
  },
  expand = {
    insert = function(snippet)
      return require("mini.snippets").default_insert(snippet, {
        empty_tabstop = "",
        empty_tabstop_final = "†",
      })
    end,
  },
})
vim.api.nvim_set_hl(0, "MiniSnippetsFinal", { link = "Comment" })

require("lazydev").setup()

require("blink.cmp").setup({
  sources = {
    default = { "lazydev", "lsp", "snippets", "path", "buffer", "emoji" },
    providers = {
      buffer = {
        name = "buffer",
        max_items = 4,
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
    keyword = {
      range = "full",
    },
    list = {
      selection = { preselect = true, auto_insert = false },
    },
    documentation = {
      window = {
        border = "rounded",
        min_width = 20,
        max_width = 100,
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
          { "kind_icon", gap = 1, "label" },
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
    kind_icons = tools.ui.kind_icons_spaced,
  },
})

require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    bib = { "bibtex-tidy" },
    html = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "black" },
    tex = { "tex-fmt" },
  },
  formatters = {
    ["tex-fmt"] = {
      prepend_args = { "--nowrap", "--tabsize", "4" },
    },
  },
})
vim.keymap.set(
  "n",
  "<leader>f",
  function() require("conform").format() end,
  { desc = "[f]ormat with LSP" }
)

require("dropbar").setup({
  icons = {
    ui = { bar = { separator = " " .. tools.ui.icons.r_chev } },
    kinds = {
      symbols = tools.ui.kind_icons_spaced,
    },
  },
  bar = {
    enable = function(buf, win, _)
      if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or vim.fn.win_gettype(win) ~= ""
        or vim.wo[win].winbar ~= ""
        or vim.bo[buf].ft == "help"
      then
        return false
      end

      local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
      if stat and stat.size > 1024 * 1024 then return false end

      return vim.bo[buf].ft == "markdown"
        or vim.bo[buf].ft == "text"
        or vim.bo[buf].bt == ""
        or pcall(vim.treesitter.get_parser, buf)
        or not vim.tbl_isempty(vim.lsp.get_clients({
          bufnr = buf,
          method = "textDocument/documentSymbol",
        }))
    end,
    update_debounce = 100,
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")

      if vim.bo[buf].ft == "markdown" then return { sources.markdown } end
      if vim.bo[buf].buftype == "terminal" then return { sources.terminal } end
      return {
        utils.source.fallback({
          sources.lsp,
          sources.treesitter,
        }),
      }
    end,
  },
})

require("edgy").setup({
  animate = { enabled = false },
  exit_when_last = true,
  right = {
    {
      title = "Outline",
      ft = "aerial",
      open = "AerialToggle",
      size = {
        width = 0.13,
      },
    },
  },
  icons = {
    closed = " " .. tools.ui.icons.r_chev,
    open = " " .. tools.ui.icons.d_chev,
  },
})

require("fidget").setup({
  progress = {
    suppress_on_insert = true,
    display = {
      done_ttl = 2,
      done_icon = tools.ui.icons.ok,
      progress_icon = {
        pattern = {
          " 󰫃 ",
          " 󰫄 ",
          " 󰫅 ",
          " 󰫆 ",
          " 󰫇 ",
          " 󰫈 ",
        },
      },
      done_style = "Comment",
      group_style = "Comment",
      icon_style = "Comment",
      progress_style = "Comment",
    },
  },
  notification = {
    window = {
      border_hl = "Comment",
      normal_hl = "Comment",
      winblend = 100,
      border = "solid",
      relative = "win",
    },
  },
})

require("symbol-usage").setup({
  text_format = function(symbol)
    local res = {}

    if symbol.references then
      local usage = symbol.references == 1 and "reference" or "references"
      table.insert(
        res,
        { ("󰌹  %s %s"):format(symbol.references, usage), "LspCodeLens" }
      )
    end

    return res
  end,
})

local actions = require("fzf-lua.actions")
local fzf = require("fzf-lua")

fzf.setup({
  actions = {
    files = {
      ["enter"] = actions.file_edit,
    },
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  buffers = {
    cwd_prompt = false,
    ignore_current_buffer = true,
    prompt = "Buffers: ",
  },
  files = {
    cwd_prompt = false,
    prompt = "Files: ",
    formatter = "path.filename_first",
  },
  grep = {
    cmd = "rg -o -n -r '' --column --no-heading --smart-case",
    prompt = "Text: ",
  },
  lsp = {
    prompt_postfix = ": ",
  },
  defaults = {
    git_icons = false,
  },
  fzf_colors = {
    ["bg"] = { "bg", "NormalFloat" },
    ["bg+"] = { "bg", "CursorLine" },
    ["fg"] = { "fg", "Comment" },
    ["fg+"] = { "fg", "Normal" },
    ["hl"] = { "fg", "CmpItemAbbrMatch" },
    ["hl+"] = { "fg", "CmpItemAbbrMatch" },
    ["gutter"] = { "bg", "NormalFloat" },
    ["header"] = { "fg", "NonText" },
    ["info"] = { "fg", "NonText" },
    ["pointer"] = { "bg", "Cursor" },
    ["separator"] = { "bg", "NormalFloat" },
    ["spinner"] = { "fg", "NonText" },
  },
  fzf_opts = { ["--keep-right"] = "" },
  hls = {
    border = "FloatBorder",
    header_bind = "NonText",
    header_text = "NonText",
    help_normal = "NonText",
    normal = "NormalFloat",
    preview_border = "FloatBorder",
    preview_normal = "NormalFloat",
    search = "CmpItemAbbrMatch",
    title = "FloatTitle",
  },
  winopts = {
    backdrop = 90,
    cursorline = true,
    height = 0.75,
    width = 0.93,
    row = 0.5,
    preview = {
      layout = "horizontal",
      scrollbar = "border",
      vertical = "up:65%",
    },
  },
})

fzf.register_ui_select()

vim.keymap.set("n", "<F6>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "\\", fzf.tabs, { desc = "Select Tab" })
vim.keymap.set("n", "|", fzf.buffers, { desc = "Select Buffer" })
vim.keymap.set("n", "<C-f>", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
vim.keymap.set(
  "n",
  "<leader>df",
  fzf.lsp_definitions,
  { silent = true, desc = "LSP [d]e[f]initions" }
)
vim.keymap.set(
  "n",
  "<leader>dd",
  fzf.lsp_document_diagnostics,
  { silent = true, desc = "LSP [d]oc [d]iagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>R",
  fzf.lsp_references,
  { silent = true, desc = "LSP [R]eferences" }
)
vim.keymap.set(
  "n",
  "<leader>ci",
  fzf.lsp_incoming_calls,
  { silent = true, desc = "LSP [i]ncoming [c]alls" }
)
vim.keymap.set(
  "n",
  "<leader>co",
  fzf.lsp_outgoing_calls,
  { silent = true, desc = "LSP [o]utgoing [c]alls" }
)

vim.api.nvim_create_user_command(
  "Highlights",
  function() require("fzf-lua").highlights() end,
  {}
)
vim.api.nvim_create_user_command("Keymaps", function() fzf.keymaps() end, {})

require("gitsigns").setup({
  attach_to_untracked = false,
  preview_config = {
    border = "solid",
    row = 1,
    col = 1,
  },
  signcolumn = true,
  signs = {
    change = { text = "┋" },
  },
  signs_staged = {
    change = { text = "┋" },
  },
  update_debounce = 500,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>gb", function() gs.blame_line({ full = false }) end)
    map("n", "<leader>gd", gs.diffthis)
    map("n", "<leader>gD", function() gs.diffthis("~") end)
    map("n", "<leader>gt", gs.toggle_signs)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hu", gs.undo_stage_hunk)

    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")

    for map_str, fn in pairs({
      ["]h"] = gs.next_hunk,
      ["[h"] = gs.prev_hunk,
    }) do
      map("n", map_str, function()
        if vim.wo.diff then return map_str end
        vim.schedule(function() fn() end)
        return "<Ignore>"
      end, { expr = true })
    end
  end,
})

local function lens(render, pos_list, nearest, wkg_i, _)
  local hl = "Folded"
  local pattern = vim.fn.getreg("/")
  pattern = pattern:gsub("^\\<", ""):gsub("\\>$", "")

  local cur_ratio = "(" .. ("%d/%d"):format(wkg_i, #pos_list) .. ")"
  local chunks = {
    { "   ", "Ignore" },
    { [[ ⌕ "]], hl },
    { pattern, hl },
    { [[" ]], hl },
    { cur_ratio, hl },
    { " ", hl },
  }

  local lnum, col = pos_list[wkg_i][1], pos_list[wkg_i][2]
  render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
end

require("hlslens").setup({
  calm_down = true,
  enable_incsearch = false,
  override_lens = lens,
})

do
  local map = vim.api.nvim_set_keymap
  local kopts = { noremap = true, silent = true }

  map(
    "n",
    "j",
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts
  )
  map(
    "n",
    "J",
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts
  )
  map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
  map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
  map("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
  map("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
  map("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
end

require("mini.icons").setup((function()
  local mini = require("mini.icons")

  local make_icon_tbl = function(category)
    local res = {}
    local postfix = "  "

    for _, name in ipairs(mini.list(category)) do
      res[name] = { glyph = " " .. mini.get(category, name) .. postfix }
    end

    return res
  end

  local default_icon = { glyph = "   " }

  local defaults = make_icon_tbl("default")
  defaults.extension = default_icon
  defaults.file = default_icon
  defaults.filetype = default_icon

  local file_icons = make_icon_tbl("file")
  file_icons[".zshrc"] = { glyph = " 󰒓  " }
  file_icons["init.lua"] = { glyph = " 󰢱  ", hl = "MiniIconsAzure" }
  file_icons["README.md"] = { glyph = "   ", hl = "MiniIconsCyan" }

  local ft_icons = make_icon_tbl("filetype")
  ft_icons.dosini = default_icon
  ft_icons.text = default_icon

  return {
    default = defaults,
    directory = make_icon_tbl("directory"),
    extension = make_icon_tbl("extension"),
    file = file_icons,
    filetype = ft_icons,
    lsp = make_icon_tbl("lsp"),
  }
end)())

require("illuminate").configure({
  delay = 350,
  filetypes_denylist = {
    "aerial",
    "neo-tree",
  },
  modes_denylist = { "v", "V" },
  under_cursor = false,
})

require("hl_match_area").setup({
  highlight_in_insert_mode = false,
})

require("mason").setup({
  max_concurrent_installers = 20,
  ui = {
    height = 0.8,
    icons = {
      package_installed = tools.ui.icons.bullet,
      package_pending = tools.ui.icons.ellipses,
      package_uninstalled = tools.ui.icons.open_bullet,
    },
  },
})

do
  local installed_packs = require("mason-registry").get_installed_packages()
  local lsp_config_names = vim
    .iter(installed_packs)
    :fold({}, function(acc, pack)
      table.insert(acc, pack.spec.neovim and pack.spec.neovim.lspconfig)
      return acc
    end)
  vim.lsp.enable(lsp_config_names)
end

require("ufo").setup({
  enable_get_fold_virt_text = true,
  fold_virt_text_handler = function(virtText, _, endLnum, width, truncate, ctx)
    -- NOTE: the original snippet referenced `suffix` without defining it.
    -- This keeps the handler valid while preserving the rest of the logic.
    local suffix = ""
    local filling = table.concat({ " ", tools.ui.icons.ellipses, " " })
    table.insert(virtText, { filling, "Folded" })
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    local endVirtText = ctx.get_fold_virt_text(endLnum)
    for i, chunk in ipairs(endVirtText) do
      local chunkText = chunk[1]
      local hlGroup = chunk[2]
      if i == 1 then chunkText = chunkText:gsub("^%s+", "") end
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(virtText, { chunkText, hlGroup })
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        table.insert(virtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    return virtText
  end,
  open_fold_hl_timeout = 0,
  provider_selector = function() return { "treesitter", "indent" } end,
})

require("statuscol").setup({
  relculright = true,
  thousands = ",",
  ft_ignore = {
    "aerial",
    "help",
    "neo-tree",
    "toggleterm",
  },
  segments = {
    {
      sign = {
        namespace = { "diagnostic" },
      },
      condition = {
        function() return tools.diagnostics_available() or " " end,
      },
    },
    {
      text = { " " },
    },
    {
      text = {
        "%=",
        function(args)
          local mode = vim.fn.mode()
          local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

          if normalized_mode ~= "v" and vim.v.virtnum == 0 then
            return require("statuscol.builtin").lnumfunc(args)
          end

          if vim.v.virtnum < 0 then return "-" end

          local line = require("statuscol.builtin").lnumfunc(args)

          if vim.v.virtnum > 0 then
            local num_wraps = vim.api.nvim_win_text_height(args.win, {
              start_row = args.lnum - 1,
              end_row = args.lnum - 1,
            }).all - 1

            if vim.v.virtnum == num_wraps then
              line = "└"
            else
              line = "├"
            end
          end

          if normalized_mode == "v" then
            local pos_list = vim.fn.getregionpos(
              vim.fn.getpos("v"),
              vim.fn.getpos("."),
              { type = mode, eol = true }
            )
            local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]

            if vim.v.lnum >= s_row and vim.v.lnum <= e_row then
              return tools.hl_str("CursorLineNr", line)
            end
          end

          return vim.fn.line(".") == vim.v.lnum
              and tools.hl_str("CursorLineNr", line)
            or tools.hl_str("LineNr", line)
        end,
        " ",
      },
      condition = {
        function() return vim.wo.number or vim.wo.relativenumber end,
      },
    },
    {
      sign = {
        namespace = { "gitsigns" },
        maxwidth = 1,
        colwidth = 1,
      },
      condition = {
        function()
          local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
          return tools.get_git_remote_name(root) or " "
        end,
      },
    },
    {
      text = { " " },
    },
    {
      text = { require("statuscol.builtin").foldfunc },
      condition = {
        function()
          return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) or " "
        end,
      },
    },
    {
      text = { " " },
    },
  },
})

require("substitute").setup({
  highlight_substituted_text = {
    timer = 200,
  },
  range = {
    group_substituted_text = false,
    prefix = "s",
    prompt_current_text = false,
    suffix = "",
  },
})
vim.keymap.set("n", "r", require("substitute").operator, {})
vim.keymap.set("n", "rr", require("substitute").line, {})
vim.keymap.set("n", "R", require("substitute").eol, {})
vim.keymap.set("x", "r", require("substitute").visual, {})
vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })

vim.keymap.set("n", "<left>", "<Plug>(swap-prev)", {})
vim.keymap.set("n", "<right>", "<Plug>(swap-next)", {})

require("tidy").setup({
  only_insert_lines = false,
  filetype_exclude = { "diff" },
  provide_undefined_editorconfig_behavior = true,
})
vim.keymap.set("n", "<leader>tt", require("tidy").toggle, {})

require("tiny-glimmer").setup({
  refresh_interval_ms = 1,
  overwrite = {
    paste = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "CurSearch",
        },
      },
    },
    undo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "DiffDelete",
        },
      },
    },
    redo = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "DiffAdd",
        },
      },
    },
  },
  animations = {
    fade = {
      to_color = "Normal",
      min_duration = 300,
      max_duration = 300,
      chars_for_max_duration = 1,
    },
    left_to_right = {
      to_color = "Normal",
      min_duration = 300,
      max_duration = 300,
      chars_for_max_duration = 1,
    },
  },
})

require("nvim-treesitter").setup({
  sync_install = false,
  ignore_install = {},
  highlight = { enable = true },
  indent = { enable = true },
  fold = { enable = false },
  textobjects = {
    lookahead = true,
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]["] = "@class.outer",
        ["]F"] = "@function.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["]F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
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
    swap = { enable = false },
  },
})

do
  local ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "git_config",
    "git_rebase",
    "html",
    "http",
    "javascript",
    "json",
    "latex",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "regex",
    "rust",
    "ssh_config",
    "svelte",
    "typescript",
    "vimdoc",
    "yaml",
  }

  local installed = require("nvim-treesitter").get_installed()
  local to_install = vim
    .iter(ensure_installed)
    :filter(function(parser) return not vim.tbl_contains(installed, parser) end)
    :totable()

  for _, parser in pairs(to_install) do
    require("nvim-treesitter.install").install(parser)
  end
end

require("neogen").setup({
  languages = {
    lua = {
      template = {
        annotation_convention = "ldoc",
      },
    },
    python = {
      template = {
        annotation_convention = "numpydoc",
      },
    },
  },
})
vim.keymap.set("n", "<leader>id", require("neogen").generate, {})

require("mini.splitjoin").setup((function()
  local pairs = {
    "%b()",
    "%b<>",
    "%b[]",
    "%b{}",
  }

  return {
    detect = {
      brackets = pairs,
      separator = "[,;]",
      exclude_regions = {},
    },
    mappings = {
      toggle = "gS",
    },
  }
end)())

do
  local MiniSplitjoin = require("mini.splitjoin")
  local pairs = {
    "%b()",
    "%b<>",
    "%b[]",
    "%b{}",
  }
  local gen_hook = MiniSplitjoin.gen_hook
  local hook_pairs = { brackets = pairs }
  local add_pair_commas = gen_hook.add_trailing_separator(hook_pairs)
  local del_pair_commas = gen_hook.del_trailing_separator(hook_pairs)
  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_pair_commas } },
    join = { hooks_post = { del_pair_commas } },
  }
end

do
  local map = vim.keymap.set
  local modes = { "o", "x" }
  map(
    modes,
    "ii",
    function() require("various-textobjs").indentation(true, true) end
  )
  map(
    modes,
    "ai",
    function() require("various-textobjs").indentation(false, true) end
  )
  map(modes, "iv", function() require("various-textobjs").value(true) end)
  map(modes, "av", function() require("various-textobjs").value(false) end)
end

require("virt-column").setup({
  char = "│",
  highlight = "VertSplit",
})

-- Lazy-ish translations -----------------------------------------------------

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd.packadd("nvim-autopairs")
    require("nvim-autopairs").setup({
      break_undo = true,
      check_ts = true,
      disable_in_macro = true,
      disable_in_replace_mode = false,
      disable_in_visualblock = false,
      enable_abbr = false,
      enable_afterquote = false,
      enable_bracket_in_quote = false,
      enable_check_bracket_line = true,
      enable_moveright = false,
      ignored_next_char = [=[[%w%%%'%[%%"%.%`%$]]=],
      map_bs = true,
      map_c_h = true,
      map_c_w = false,
      map_cr = true,
      fast_wrap = {
        map = "<C-w>",
      },
    })

    local rule = require("nvim-autopairs.rule")
    local ts_conds = require("nvim-autopairs.ts-conds")
    local conds = require("nvim-autopairs.conds")

    require("nvim-autopairs").add_rules({
      rule("<", ">", "lua"):with_pair(
        ts_conds.is_ts_node({ "string", "string_content" })
      ),
      rule("<", ">", { "html", "vim", "xml" }),
      rule("![", "]()", "markdown"):set_end_pair_length(1),
      rule("^%a+%(%)", ":", "gitcommit")
        :use_regex(true)
        :with_pair(conds.not_after_regex(".+"))
        :with_pair(ts_conds.is_not_ts_node("message"))
        :with_move(function(options) return options.char == ":" end),
    })
  end,
})

local dial_loaded = false
local function ensure_dial()
  if dial_loaded then return end

  dial_loaded = true
  vim.cmd.packadd("dial.nvim")

  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    default = {
      augend.constant.alias.alpha,
      augend.constant.alias.Alpha,
      augend.constant.alias.bool,
      augend.integer.alias.decimal_int,
      augend.date.new({
        pattern = "%Y-%m-%d",
        default_kind = "day",
        only_valid = true,
      }),
      augend.date.new({
        pattern = "%m-%d",
        default_kind = "day",
        only_valid = true,
      }),
      augend.constant.new({ elements = { "and", "or" }, word = true }),
      augend.constant.new({ elements = { "True", "False" }, word = true }),
    },
  })
end

local function dial_manip(kind, mode)
  return function()
    ensure_dial()
    require("dial.map").manipulate(kind, mode)
  end
end

vim.keymap.set("n", "<C-a>", dial_manip("increment", "normal"))
vim.keymap.set("n", "<C-x>", dial_manip("decrement", "normal"))
vim.keymap.set("n", "g<C-a>", dial_manip("increment", "gnormal"))
vim.keymap.set("n", "g<C-x>", dial_manip("decrement", "gnormal"))
vim.keymap.set("v", "<C-a>", dial_manip("increment", "visual"))
vim.keymap.set("v", "<C-x>", dial_manip("decrement", "visual"))
vim.keymap.set("v", "g<C-a>", dial_manip("increment", "gvisual"))
vim.keymap.set("v", "g<C-x>", dial_manip("decrement", "gvisual"))

local link_char = "  "
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = function()
    vim.cmd.packadd("render-markdown.nvim")
    require("render-markdown").setup({
      debounce = 200,
      render_modes = true,
      code = {
        sign = false,
        border = "thin",
        below = "🮂",
        width = "block",
        position = "left",
        language_icon = false,
        language_pad = 1,
        left_pad = 1,
        right_pad = 2,
        inline_pad = 1,
        highlight = "@markup.raw.block",
        highlight_inline = "@markup.raw.markdown_inline",
        highlight_border = "@markup.raw.block",
        highlight_language = "NonText",
      },
      heading = {
        enabled = false,
        width = "block",
        position = "inline",
        backgrounds = {
          "@markup.heading.1.markdown",
        },
      },
      quote = {
        highlight = "NonText",
        repeat_linebreak = true,
      },
      bullet = {
        enabled = true,
        icons = { "■", "□", "●", "○", "◆", "◊" },
        highlight = "@markup.list.markdown",
      },
      checkbox = {
        enabled = false,
      },
      pipe_table = {
        style = "normal",
        cell = "raw",
      },
      html = { comment = { conceal = false } },
      link = {
        image = "  ",
        email = "󰇮  ",
        hyperlink = link_char,
        custom = {
          web = { pattern = "^http", icon = link_char },
          sweb = { pattern = "^https", icon = link_char },
          linkedin = { pattern = "linkedin%%.com", icon = "  " },
          youtube = { pattern = "youtube%%.com", icon = "  " },
          github = { pattern = "github%%.com", icon = "  " },
          stackoverflow = { pattern = "stackoverflow%%.com", icon = "󰓌  " },
          discord = { pattern = "discord%%.com", icon = "  " },
          reddit = { pattern = "reddit%%.com", icon = "  " },
          acm = { pattern = "dl%.acm%%.org", icon = "  " },
          arxiv = { pattern = "arxiv%%.org", icon = "  " },
        },
      },
    })
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[vV\22]",
  once = true,
  callback = function()
    vim.cmd.packadd("visual-whitespace.nvim")
    require("visual-whitespace").setup({
      fileformat_chars = {
        unix = "¬",
      },
    })
  end,
})

vim.schedule(function()
  vim.cmd.packadd("which-key.nvim")
  local wk = require("which-key")
  wk.setup({
    delay = 500,
    icons = {
      separator = "→",
      mappings = false,
    },
    layout = { align = "center" },
    triggers = {
      { "<leader>", mode = { "n", "v" } },
    },
    plugins = {
      spelling = {
        enabled = false,
      },
    },
    preset = "classic",
  })

  vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
end)
