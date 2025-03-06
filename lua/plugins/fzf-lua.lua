return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    local actions = require("fzf-lua.actions")
    local map = vim.keymap.set

    fzf.setup({
      actions    = {
        files = {
          ["enter"] = actions.file_edit,
        }
      },
      keymap     = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      buffers    = {
        cwd_prompt = false,
        ignore_current_buffer = true,
        prompt = "Buffers: ",
      },
      files      = {
        cwd_prompt = false,
        prompt = "Files: ",
        formatter = "path.filename_first"
      },
      grep       = {
        cmd = "rg -o -n -r '' --column --no-heading --smart-case",
        prompt = "Text: ",
      },
      lsp        = {
        prompt_postfix = ': ',
      },
      defaults   = {
        git_icons = false,
      },
      fzf_colors = {
        ["bg"]        = { "bg", "NormalFloat" },
        ["bg+"]       = { "bg", "CursorLine" },
        ["fg"]        = { "fg", "Comment" },
        ["fg+"]       = { "fg", "Normal" },
        ["hl"]        = { "fg", "CmpItemAbbrMatch" },
        ["hl+"]       = { "fg", "CmpItemAbbrMatch" },
        ["gutter"]    = { "bg", "NormalFloat" },
        ["header"]    = { "fg", "NonText" },
        ["info"]      = { "fg", "NonText" },
        ["pointer"]   = { "bg", "Cursor" },
        ["separator"] = { "bg", "NormalFloat" },
        ["spinner"]   = { "fg", "NonText" },
      },
      fzf_opts   = { ['--keep-right'] = '' },
      hls        = {
        border = "FloatBorder",
        header_bind = "NonText",
        header_text = "NonText",
        help_normal = "NonText",
        normal = "NormalFloat",
        preview_border = "FloatBorder",
        preview_normal = "NormalFloat",
        search = "CmpItemAbbrMatch",
        title = "FloatTitle"
      },
      winopts    = {
        backdrop   = 100,
        border     = tools.ui.borders.thin,
        cursorline = true,
        height     = .25,
        width      = 1,
        row        = 1,

        preview    = {
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

    --  LSP
    map("n", "<leader>df", fzf.lsp_definitions, { silent = true, desc = "LSP [d]e[f]initions" })
    map("n", "<leader>dd", fzf.lsp_document_diagnostics, { silent = true, desc = "LSP [d]oc [d]iagnostics" })
    map("n", "<leader>R", fzf.lsp_references, { silent = true, desc = "LSP [R]eferences" })
    map("n", "<leader>ci", fzf.lsp_incoming_calls, { silent = true, desc = "LSP [i]ncoming [c]alls" })
    map("n", "<leader>co", fzf.lsp_outgoing_calls, { silent = true, desc = "LSP [o]utgoing [c]alls" })

    vim.api.nvim_create_user_command("Highlights", function() require('fzf-lua').highlights() end, {})
    vim.api.nvim_create_user_command("Keymaps", function() fzf.keymaps() end, {})
  end
}
