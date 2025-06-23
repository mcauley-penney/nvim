local short_indent = {
  ["css"] = true,
  ["javascript"] = true,
  ["javascriptreact"] = true,
  ["json"] = true,
  ["lua"] = true,
  ["markdown"] = true,
  ["org"] = true,
  ["tex"] = true,
  ["text"] = true,
  ["yaml"] = true,
}

local nonstandard_tw = {
  ["c"] = 120,
  ["cpp"] = 120,
  ["gitcommit"] = 0,
  ["javascript"] = 120,
  ["javascriptreact"] = 120,
  ["json"] = 0,
  ["lua"] = 120,
  ["markdown"] = 0,
  ["python"] = 120,
  ["tex"] = 0,
  ["plaintex"] = 0,
  ["whsp"] = 0,
  ["txt"] = 0,
}

local M = {
  set_indent = function(ft)
    local indent = short_indent[ft] and 2 or 4
    vim.api.nvim_set_option_value("tabstop", indent, {})
    vim.api.nvim_set_option_value("shiftwidth", 0, {})
  end,

  set_textwidth = function(ft)
    local tw = nonstandard_tw[ft] or 80
    tw = tools.nonprog_modes[ft] and 0 or tw

    vim.api.nvim_set_option_value("textwidth", tw, {})
  end,

  update_formatlistpat = function()
    local cstr = vim.bo.commentstring
    if not cstr or cstr == "" or cstr == "%s" then return end

    local prefix = cstr:gsub("%%s", "")
    prefix = prefix:gsub("([\\.*^$~%[%]])", "\\%1")

    local pattern = "^\\s*" .. prefix .. "\\s\\+"
    vim.opt.formatlistpat:append(pattern)
  end,

  --- Sets up LSP keymaps and autocommands for the given buffer.
  on_attach = function(client, bufnr)
    local lsp = vim.lsp.buf
    local methods = vim.lsp.protocol.Methods

    --- @param mode string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param desc string
    local function map(mode, lhs, rhs, desc)
      mode = mode or "n"
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map(
      "n",
      "<leader>vd",
      function() vim.diagnostic.open_float({ border = "solid" }) end,
      "[v]iew [d]iagnostic float"
    )

    --  if client:supports_method(methods.textDocument_formatting) then
    --    map('n', "<leader>f", function() lsp.format({ timeout_ms = 2000 }) end, "[f]ormat with LSP")
    --  end

    -- https://github.com/neovim/neovim/commit/448907f65d6709fa234d8366053e33311a01bdb9
    -- https://reddit.com/r/neovim/s/eDfG5BfuxW
    if client:supports_method(methods.textDocument_inlayHint) then
      map(
        "n",
        "<leader>th",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        "[t]oggle inlay [h]ints"
      )
    end

    if client:supports_method(methods.textDocument_rename) then
      map("n", "<leader>r", require("aucmd.rename").rename, "[r]ename")
    end

    if client:supports_method(methods.textDocument_declaration) then
      map("n", "<leader>de", lsp.declaration, "go to [de]claration")
    end

    if client:supports_method(methods.textDocument_hover) then
      map("n", "K", function() lsp.hover({ border = "solid" }) end, "LSP hover")
    end

    if client:supports_method(methods.textDocument_signatureHelp) then
      map("i", "<C-k>", lsp.signature_help, "LSP signature help")
    end
  end,
}

return M
