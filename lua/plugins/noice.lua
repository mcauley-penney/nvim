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
        progress = { enabled = true },
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
        mini = {
          position = {
            row = -2,
          },
        },
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      local hl = vim.api.nvim_set_hl
      local prg = "NoiceLspProgress"

      hl(0, "NoiceMini", { link = "LspInlayHint" })
      hl(0, "NoiceFormatProgressDone", { link = "Normal" })
      hl(0, prg .. "Client", { link = "LspInlayHint" })
      hl(0, prg .. "Title", { link = "LspInlayHint" })
      hl(0, prg .. "Spinner", { link = "LspInlayHint" })
    end
  }
}
