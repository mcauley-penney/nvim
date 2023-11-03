return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      local map = vim.keymap.set
      local actions = require("fzf-lua.actions")

      fzf.setup({
        files = {
          --  cwd_header = true,
          cwd_prompt = false,
          prompt = "📂  ",
          actions = {
            ["default"] = actions.file_open_in_background,
          }
        },
        grep = {
          prompt = "🔎  ",
        },
        fzf_colors = {
          ["bg+"] = { "bg", "visual" },
          bg      = { "bg", "StatusLine" },
          ["hl+"] = { "fg", "Statement" },
          gutter  = { "bg", "StatusLine" },
          info    = { "fg", "Conditional" },

          --  ["bg"]      = { "bg", "Normal" },
          --  ["hl"]      = { "fg", "Comment" },
          --  ["fg+"]     = { "fg", "Normal" },
          --  ["bg+"]     = { "bg", "CursorLine" },
          --  ["info"]    = { "fg", "PreProc" },
          --  ["prompt"]  = { "fg", "Conditional" },
          --  ["pointer"] = { "fg", "Exception" },
          --  ["marker"]  = { "fg", "Keyword" },
          --  ["spinner"] = { "fg", "Label" },
          --  ["header"]  = { "fg", "Comment" },
          --  ["gutter"]  = { "bg", "Normal" },
        },
        fzf_opts = { ['--keep-right'] = '' },
        winopts = {
          border = tools.ui.border,
          height = .80,
          hl = {
            normal = "Pmenu",
            border = "FloatBorder",
            -- Only valid with the builtin previewer:
            cursor = "Cursor",         -- cursor highlight (grep/LSP matches)
            cursorline = "StatusLine", -- cursor line
            cursorlinenr = "NonText",  -- cursor line number
            preview_border = "FloatBorder",
            preview_normal = "Statusline",
            search = "IncSearch", -- search matches (ctags|help)
            scrollbar_f = "NonText",
            title = "StatusLine"
          },
          preview = {
            layout = "vertical",
            scrollbar = "border",
            vertical = "up:65%",
          },
          width = .80,
        },
      })

      map("n", "<leader>q", fzf.quickfix, {})

      map("n", "<C-t>", fzf.files, { desc = 'Find files' })
      map("n", "\\", fzf.buffers, { desc = 'Select Buffer' })

      map("n", "<C-f>", '<cmd>FzfLua live_grep_glob<cr>', { desc = "Grep" })
      map("n", "<leader>f<", '<cmd>FzfLua resume<cr>', { desc = 'Resume last command' })

      --  LSP
      map("n", "<leader>de", fzf.lsp_definitions, { silent = true, desc = "LSP [de]finitions" })
      map("n", "<leader>dd", fzf.lsp_document_diagnostics, { silent = true, desc = "LSP [d]oc [d]iagnostics" })
      map("n", "<leader>im", fzf.lsp_implementations, { silent = true, desc = "LSP [im]plementations" })
      map("n", "<leader>R", fzf.lsp_references, { silent = true, desc = "LSP [R]eferences" })
      map("n", "<leader>ic", fzf.lsp_incoming_calls, { silent = true, desc = "LSP [i]ncoming [c]alls" })
      map("n", "<leader>oc", fzf.lsp_outgoing_calls, { silent = true, desc = "LSP [o]utgoing [c]alls" })

      vim.api.nvim_create_user_command("Highlights", function() require('fzf-lua').highlights() end, {})
      vim.api.nvim_create_user_command("Keymaps", function() fzf.keymaps() end, {})
    end
  }
}
