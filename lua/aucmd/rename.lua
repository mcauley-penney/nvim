local M = {}

local function float_input(opts, on_confirm)
  local buf = vim.api.nvim_create_buf(false, false)
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"

  vim.keymap.set(
    { "i", "n" },
    "<cr>",
    "<cr><esc><cmd>close!<cr><cmd>stopinsert<cr>",
    {
      silent = true,
      buffer = buf,
    }
  )

  vim.keymap.set("n", "u", "<cmd>undo<cr>", {
    silent = true,
    buffer = buf,
  })

  for _, lhs in pairs({ "<esc>", "q" }) do
    vim.keymap.set("n", lhs, "<cmd>close!<cr>", {
      silent = true,
      buffer = buf,
    })
  end

  vim.fn.prompt_setprompt(buf, " ")
  vim.fn.prompt_setcallback(buf, function(input)
    vim.defer_fn(function() on_confirm(input) end, 10)
  end)

  local default_text = opts.default or ""

  local win_opts = {
    border = "solid",
    col = 0,
    focusable = true,
    height = 1,
    relative = "cursor",
    row = 1,
    style = "minimal",
    width = #default_text + 15,
    title = { { opts.prompt, "FloatTitle" } },
    title_pos = "left",
  }

  vim.api.nvim_open_win(buf, true, win_opts)

  vim.cmd("startinsert")

  vim.defer_fn(function()
    vim.api.nvim_buf_set_text(buf, 0, 1, 0, 1, { default_text })
    vim.cmd("stopinsert")
    vim.api.nvim_win_set_cursor(0, { 1, 2 })
  end, 10)
end

function M.rename()
  local curr = vim.fn.expand("<cword>")
  float_input({ prompt = " Rename › ", default = curr }, function(new_name)
    if not new_name or new_name == "" or new_name == curr then return end

    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local enc = clients[1] and clients[1].offset_encoding or "utf-16"
    local params = vim.lsp.util.make_position_params(0, enc)
    params["newName"] = new_name

    vim.lsp.buf_request(
      0,
      "textDocument/rename",
      params,
      function(err, res, ctx)
        if err or not res then return end

        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end

        vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

        local function count(edit)
          local files, instances = 0, 0
          if edit.documentChanges then
            for _, f in pairs(edit.documentChanges) do
              files, instances = files + 1, instances + #f.edits
            end
          elseif edit.changes then
            for _, f in pairs(edit.changes) do
              files, instances = files + 1, instances + #f
            end
          end
          return instances, files
        end

        local n, f = count(res)
        vim.notify(
          string.format(
            "%d occurrence%s renamed in %d file%s%s",
            n,
            n == 1 and "" or "s",
            f,
            f == 1 and "" or "s",
            f > 0 and ".  :wa to save" or ""
          )
        )
      end
    )
  end)
end

return M
