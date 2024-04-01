return {
  "MunifTanjim/nui.nvim",

  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = { enabled = false },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        -- otherwise, see https://github.com/MariaSolOs/dotfiles/blob/40da0d80859b27b33b7d252677c448b74c813d65/.config/nvim/lua/lsp.lua#L167-L251
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = false },
      },
      messages = { enabled = false },
      notify = { enabled = false },
      popupmenu = { enabled = false },
      presets = {
        lsp_doc_border = true,
      },
      smart_move = {
        excluded_filetypes = {},
      },
      views = {
        hover = {
          border = { style = tools.ui.cur_border },
        },
      },
    },
  }
}
