local augrp = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd
local get_opt = vim.api.nvim_get_option_value
local aucmd_fn = require("aucmd.functions")
local grp

---- Upon entering
grp = augrp("Entering", { clear = true })

aucmd("BufEnter", {
  group = grp,
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    local root = tools.get_path_root(path)

    if root ~= nil then
      vim.cmd.lcd(vim.fn.fnameescape(root))

      tools.get_git_branch(root)
      tools.get_git_remote_name(root)
    end
  end,
  desc = "Set root dir and initialize version control branch",
})

aucmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    local list_types = table.concat({
      [[^\s*[-*+]\s\+]], -- Markdown unordered lists
      [[^\s*\w\+[\]:.)}\t ]\s\+]], -- word/letter lists
      [[^\s*>\s]], -- blockquotes: > quote
    }, [[\|]])

    vim.opt_local.formatlistpat:append([[\|]] .. list_types)
  end,
})

aucmd("FileType", {
  group = grp,
  callback = function()
    vim.opt_local.formatoptions = "2cjnpqrt"

    -- Dynamically append commentstring-based pattern to formatlistpat
    local commentstring = vim.bo.commentstring:match("^(.*)%%s$")
    if commentstring then
      vim.opt.formatlistpat:append([[\|^\s*]] .. commentstring .. [[\s*]])
    end

    local ft = get_opt("filetype", {})
    aucmd_fn.set_indent(ft)
    aucmd_fn.set_textwidth(ft)
  end,
  desc = "Set formatting options after ftplugins",
})

aucmd("BufNewFile", {
  group = grp,
  command = "silent! 0r "
    .. vim.fn.stdpath("config")
    .. "/templates/skeleton.%:e",
  desc = "If one exists, use a template when opening a new file",
})

aucmd("BufWinEnter", {
  group = grp,
  command = "silent! loadview",
  desc = "Restore view settings",
})

-- See https://vi.stackexchange.com/a/12710
aucmd({ "WinEnter", "BufWinEnter" }, {
  group = grp,
  callback = function()
    if vim.w.email_match_id then return end
    vim.w.email_match_id = vim.fn.matchadd(
      "String",
      "\v[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}"
    )
  end,
  desc = "Highlight email addresses",
})

---- LSP
aucmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    aucmd_fn.on_attach(client, args.buf)
  end,
})

---- during editing
grp = augrp("Editing", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = grp,
  command = [[tabdo wincmd =]],
})

---- Upon leaving a buffer
grp = augrp("Leaving", { clear = true })

aucmd("BufWinLeave", {
  group = grp,
  command = "silent! mkview",
  desc = "Create view settings",
})
