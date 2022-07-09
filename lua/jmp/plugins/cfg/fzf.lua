local float_border = require("jmp.style").border

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
  files = {
    prompt = "🔎 ",
    actions = {
      ["default"] = actions.file_open_in_background,
    },
  },

  fzf_colors = {
    ["bg+"] = { "bg", "StatusLine" },
    ["gutter"] = { "bg", "StatusLine" },
  },

  keymap = {
    builtin = {
      ["<S-down>"] = "preview-page-down",
      ["<S-up>"] = "preview-page-up",
    },
  },

  winopts = {
    border = float_border,
    hl = {
      normal = "Pmenu",
      border = "FloatBorder",
      -- Only valid with the builtin previewer:
      cursor = "Cursor", -- cursor highlight (grep/LSP matches)
      cursorline = "StatusLine", -- cursor line
      cursorlinenr = "NonText", -- cursor line number
      search = "IncSearch", -- search matches (ctags|help)
      scrollbar_f = "NonText",
    },

    preview = {
      layout = "vertical",
      scrollbar = "border",
      vertical = "up:65%",
    },
  },
})
