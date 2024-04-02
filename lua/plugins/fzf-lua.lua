return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    local map = vim.keymap.set

    fzf.setup({
      buffers = {
        cwd_prompt = false,
        ignore_current_buffer = true,
        prompt = "   ",
      },
      files = {
        cwd_prompt = false,
        prompt = "   ",
      },
      grep = {
        cmd = "rg -o -r '' --column --no-heading --color=never --smart-case",
        prompt = "   ",
        fzf_opts = {
          ['--keep-right'] = '',
        },
      },
      global_git_icons = false,
      fzf_colors = {
        ["bg"]        = { "bg", "NormalFloat" },
        ["bg+"]       = { "bg", "CursorLine" },
        ["fg+"]       = { "fg", "CursorLine" },
        ["gutter"]    = { "bg", "NormalFloat" },
        ["header"]    = { "fg", "NonText" },
        ["info"]      = { "fg", "NonText" },
        ["pointer"]   = { "bg", "Cursor" },
        --  ["prompt"]    = { "fg", "Number" },
        ["separator"] = { "bg", "NormalFloat" },
        ["spinner"]   = { "fg", "NonText" },
      },
      fzf_opts = { ['--keep-right'] = '' },
      winopts = {
        cursorline = true,
        border = tools.ui.cur_border,
        height = .35,
        width = 1,
        row = 1,
        hl = {
          border = "FloatBorder",
          header_bind = "NonText",
          header_text = "NonText",
          help_normal = "NonText",
          normal = "NormalFloat",
          preview_border = "NormalFloat",
          preview_normal = "NormalFloat",
          search = "IncSearch",
          title = "FloatTitle"
        },
        preview = {
          layout = "horizontal",
          scrollbar = "border",
          vertical = "up:65%",
        },
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
