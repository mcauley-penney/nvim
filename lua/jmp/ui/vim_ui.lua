--- Conduct user input in a floating window.
-- vim.ui.input: https://github.com/neovim/neovim/blob/6e6f5a783333d1bf9d6c719c896e72ac82e1ae54/runtime/lua/vim/ui.lua#L85-L97
-- Original: https://www.reddit.com/r/neovim/comments/ua6826/3_lua_override_vimuiinput_in_40_lines/
-- Credit: tLaw101, with modifications by me :)
-- @tparam  opts
-- @tparam  on_confirm
-- @tparam  input
vim.ui.input = function(opts, on_confirm)
  -- defer the on_confirm callback so that it is
  -- executed after the prompt window is closed
  local deferred_callback = function(input)
    vim.defer_fn(function()
      on_confirm(input)
    end, 10)
  end

  -- create a "prompt" buffer that will be deleted once focus is lost
  local buf = vim.api.nvim_create_buf(false, false)
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"

  local default_text = opts.default or ""
  local prompt = (" " .. opts.prompt) or " "

  local win_opts = {
    border = "none",
    col = 0,
    focusable = true,
    height = 2,
    relative = "cursor",
    row = 1,
    style = "minimal",
    width = #prompt + #default_text + 15
  }

  -- set keymaps
  vim.keymap.set({ "i", "n" }, "<CR>", "<CR><Esc>:close!<CR>:stopinsert<CR>", {
    silent = true,
    buffer = buf,
  })

  -- TODO: janky. Figure out why 'u' doesn't work in prompt buf
  vim.keymap.set("n", "u", ":undo<CR>", {
    silent = true,
    buffer = buf,
  })

  for _, lhs in pairs({ "<esc>", "q" }) do
    vim.keymap.set("n", lhs, "<cmd>close!<CR>", {
      silent = true,
      buffer = buf,
    })
  end

  -- set prompt and callback (CR) for prompt buffer
  vim.fn.prompt_setprompt(buf, prompt)
  vim.fn.prompt_setcallback(buf, deferred_callback)

  -- open the floating window pointing to our buffer and show the prompt
  vim.api.nvim_open_win(buf, true, win_opts)

  vim.cmd("startinsert")

  -- set the default text (needs to be deferred after the prompt is drawn)
  vim.defer_fn(function()
    vim.api.nvim_buf_set_text(buf, 0, #prompt, 0, #prompt, { default_text })
    vim.cmd("stopinsert")
    vim.api.nvim_win_set_cursor(0, { 1, #prompt + 1 })
  end, 5)
end
