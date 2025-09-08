local map = vim.keymap.set

vim.g.mapleader = "m"
vim.g.localmapleader = ","

local function swap_map(lhs, rhs, mode)
  map(mode or "", lhs, rhs, {})
  map(mode or "", rhs, lhs, {})
end

local dash = "- "
local fslash = "// "

local ft_cstr_overrides = {
  ["c"] = fslash,
  ["cpp"] = fslash,
}

local function send_comment()
  local unwrap_cstr = function(cstr)
    local left, right = string.match(cstr, "(.*)%%s(.*)")
    return vim.trim(left), vim.trim(right)
  end

  local ft = vim.api.nvim_get_option_value("filetype", {})
  local cstr = ft_cstr_overrides[ft]
  if cstr then return cstr end

  cstr = vim.bo.commentstring
  if cstr == "" or cstr == nil then return dash end

  local pos_tbl = vim.api.nvim_win_get_cursor(0)
  local row, col = pos_tbl[1] - 1, pos_tbl[2]

  local left_cstr, right_cstr = unwrap_cstr(cstr)
  local inc_len = string.find(cstr, "%s*%%s") - 1

  vim.schedule(function()
    vim.api.nvim_buf_set_text(
      0,
      row,
      col,
      row,
      col,
      { left_cstr .. " " .. right_cstr }
    )
    vim.api.nvim_win_set_cursor(0, { row + 1, col + inc_len + 1 })
  end)
end

--------------------------------------------------
-- Colemak
--------------------------------------------------
local colemak_maps = {
  { "n", "j" }, -- down
  { "e", "k" }, -- up
  { "s", "h" }, -- left
  { "t", "l" }, -- right
}
local mvmnt_prefix = "<C-w><C-"

for _, pairs in ipairs(colemak_maps) do
  local lhs = pairs[1]
  local rhs = pairs[2]

  local mvmnt_lhs = table.concat({ mvmnt_prefix, lhs, ">" })
  local mvmnt_rhs = table.concat({ mvmnt_prefix, rhs, ">" })

  -- lowercase
  swap_map(lhs, rhs)

  -- uppercase
  swap_map(string.upper(lhs), string.upper(rhs))

  -- window movement
  swap_map(mvmnt_lhs, mvmnt_rhs)
end

map("n", "e", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "n", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("v", "e", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("v", "n", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--------------------------------------------------
-- Base
--------------------------------------------------
map("n", "<F1>", "za", {})

map("i", "<F6>", send_comment, { expr = true, silent = true })

map("n", "<CR>", ":", { desc = "Enter command mode" })
map("v", "<CR>", ":", { desc = "Enter command mode" })

-- space for insert mode
map("n", "<Space>", "a", { remap = true })
map("v", "<Space>", "I", {})

-- make single char case change more accessible
swap_map("`", "~", { "n", "v" })

-- tab and bs for indentation
map("n", "<tab>", ">>", {})
map("n", "<bs>", "<<", {})

map("", "<home>", "^", { desc = "move to first non-blank char in line" })
map(
  "i",
  "<home>",
  "<C-o>^",
  { desc = "move in front of first non-blank char in line" }
)

-- tabs and buffers
map("n", "<C-t>", "<CMD>tabnew<CR>", { desc = "Open a new tab" })
map("n", "<leader>bq", "<cmd>bd<CR>", { silent = true })
map("n", "<leader>tq", "<cmd>tabclose<CR>", { silent = true })

-- search in visual selection
map("v", "/", "<Esc>/\\%V")

map(
  "n",
  "<leader>s",
  [[:%s/<C-r><C-w>//gI<Left><Left><Left>]],
  { desc = "open %s//gI with cword" }
)

map("v", "*", "y/<C-R>0<CR>", { desc = "Search for visual selection" })
