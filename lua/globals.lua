-- https://www.compart.com/en/unicode to search Unicode

local borders = {
  none = { '', '', '', '', '', '', '', '' },
  invs = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  thin = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  edge = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }, -- Works in Kitty, Wezterm
}

_G.tools = {
  ui = {
    cur_border = borders.invs,
    borders = borders,
    icons = {
      branch = '',
      bullet = '•',
      o_bullet = '○',
      check = '✔',
      d_chev = '∨',
      ellipses = '…',
      file = '╼ ',
      hamburger = '≡',
      lock = '',
      r_chev = '>',
      location = '⌘',
      square = '🗊',
      ballot_x = '🗴',
      up_tri = '▲',
      info_i = '¡',
    }
  },
  nonprog_modes = {
    ["markdown"] = true,
    ["org"] = true,
    ["orgagenda"] = true,
    ["text"] = true,
  }
}

-- ┌────────┐
-- │settings│
-- └────────┘

-- Stop search highlighting after moving
-- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({
      "<CR>",
      "n",
      "N",
      "*",
      "#",
      "?",
      "/",
    }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, vim.api.nvim_create_namespace "auto_hlsearch")


-- ┌─────────┐
-- │functions│
-- └─────────┘
--------------------------------------------------
-- files and directories
--------------------------------------------------
-- provides a place to cache the root
-- directory for current editing session
local branch_cache = {}
local remote_cache = {}

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
tools.get_path_root = function(path)
  if path == "" then return end

  local root = vim.b.path_root
  if root ~= nil then return root end

  local root_items = {
    ".git"
  }

  root = vim.fs.root(0, root_items)
  if root == nil then return nil end
  vim.b.path_root = root

  return root
end

-- get the name of the remote repository
tools.get_git_remote_name = function(root)
  if root == nil then return end

  local remote = remote_cache[root]
  if remote ~= nil then return remote end

  -- see https://stackoverflow.com/a/42543006
  -- "basename" "-s" ".git" "`git config --get remote.origin.url`"
  local cmd = table.concat({ "git", "config", "--get remote.origin.url" }, " ")
  remote = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then return nil end

  remote = vim.fs.basename(remote)
  if remote == nil then return end

  remote = vim.fn.fnamemodify(remote, ":r")
  remote_cache[root] = remote

  return remote
end

tools.set_git_branch = function(root)
  -- For commit numbers
  --  local cmd = table.concat({ "git", "-C", root, "rev-parse --short HEAD" }, " ")

  local cmd = table.concat({
    "git", "-C", root,
    "rev-parse --abbrev-ref HEAD || git rev-parse --short HEAD"
  }, " ")

  local branch = vim.fn.system(cmd)
  if branch == nil then
    return nil
  end

  branch = branch:gsub("\n", "")
  branch_cache[root] = branch

  return branch
end

tools.get_git_branch = function(root)
  if root == nil then return end

  local branch = branch_cache[root]
  if branch ~= nil then return branch end

  return tools.set_git_branch(root)
end

tools.is_nonprog_ft = function(ft)
  return tools.nonprog_modes[ft]
end


--------------------------------------------------
-- LSP
--------------------------------------------------
tools.diagnostics_available = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

  for _, cfg in pairs(clients) do
    if cfg.supports_method(diagnostics) then return true end
  end

  return false
end

--------------------------------------------------
-- Highlighting
--------------------------------------------------
tools.hl_str = function(hl, str)
  return "%#" .. hl .. "#" .. str .. "%*"
end

-- Stolen from toggleterm.nvim
--
---Convert a hex color to an rgb color
---@param hex string
---@return number
---@return number
---@return number
local function hex_to_rgb(hex)
  if hex == nil then
    hex = "#000000"
  end
  return tonumber(hex:sub(2, 3), 16),
      tonumber(hex:sub(4, 5), 16),
      tonumber(hex:sub(6), 16)
end


-- Stolen from toggleterm.nvim
--
-- SOURCE: https://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
-- @see: https://stackoverflow.com/questions/37796287/convert-decimal-to-hex-in-lua-4
--- Shade Color generate
--- @param hex string hex color
--- @param percent number
--- @return string
tools.tint = function(hex, percent)
  local r, g, b = hex_to_rgb(hex)

  -- If any of the colors are missing return "NONE" i.e. no highlight
  if not r or not g or not b then return "NONE" end

  r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
  g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
  b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
  r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

  return "#" .. string.format("%02x%02x%02x", r, g, b)
end


---Get a hl group's rgb
---Note: Always gets linked colors
---@param opts table
---@param ns_id integer?
---@return table
tools.get_hl_hex = function(opts, ns_id)
  opts, ns_id = opts or {}, ns_id or 0
  assert(opts.name or opts.id, "Error: must have hl group name or ID!")
  opts.link = true

  local hl = vim.api.nvim_get_hl(ns_id, opts)

  return {
    fg = hl.fg and ('#%06x'):format(hl.fg),
    bg = hl.bg and ('#%06x'):format(hl.bg)
  }
end

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
tools.group_number = function(num, sep)
  if num < 999 then
    return tostring(num)
  else
    num = tostring(num)
    return num:reverse():gsub('(%d%d%d)', '%1' .. sep):reverse():gsub('^,', '')
  end
end
