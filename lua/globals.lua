local borders = {
  none = { " ", " ", " ", " ", " ", " ", " ", " " },
  thin = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  edge = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }, -- Works in Kitty, Wezterm
}

_G.tools = {
  ui = {
    border = borders.edge,
    icons = {
      ballot_x = '✘',
      branch = '',
      bullet = '•',
      checkmark = '✔',
      d_chev = '∨',
      ellipses = '┉',
      hamburger = '≡',
      info_i = '¡',
      lock = '',
      r_chev = '>',
      up_tri = '▲',
    },
  }
}

_G.tools.ui.lsp_signs = {
  Error = tools.ui.icons["ballot_x"],
  Warn = tools.ui.icons["up_tri"],
  Hint = tools.ui.icons["info_i"],
  Info = tools.ui.icons["info_i"],
  Ok = tools.ui.icons["checkmark"]
}


-- ┌────────┐
-- │settings│
-- └────────┘
-- defines what filetypes should not be treated like source code
tools.nonprog_mode = {
  ["markdown"] = true,
  ["org"] = true,
  ["orgagenda"] = true,
  ["text"] = true,
}

-- ┌─────────┐
-- │functions│
-- └─────────┘
--------------------------------------------------
-- project directories
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

  root = vim.fs.find(root_items, {
    path = path,
    upward = true,
    type = "directory"
  })[1]
  if root == nil then return nil end

  root = vim.fs.dirname(root)
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
  local cmd = table.concat({ "git", "-C", root, "branch --show-current" }, " ")
  local branch = vim.fn.system(cmd)
  if branch == nil then return nil end

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

--------------------------------------------------
-- Highlights
--------------------------------------------------
tools.make_hl_grpstr = function(grp_name)
  return table.concat({ "%#", grp_name, "#" }, "")
end

tools.make_hl_grp = function(grp_name, hi)
  vim.api.nvim_set_hl(0, grp_name, hi)
  return tools.make_hl_grpstr(grp_name)
end

tools.hl_str_grpstr = function(hl_grp_str, text)
  return table.concat({ hl_grp_str, text, "%*" })
end

tools.hl_str_grpname = function(grp_name, text)
  local hl_grp_str = tools.make_hl_grpstr(grp_name)
  return tools.hl_str_grpstr(hl_grp_str, text)
end


-- Stolen from toggleterm.nvim
--
---Convert a hex color to an rgb color
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
  return tonumber(color:sub(2, 3), 16),
      tonumber(color:sub(4, 5), 16),
      tonumber(color:sub(6), 16)
end

-- Stolen from toggleterm.nvim
--
-- SOURCE: https://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
-- @see: https://stackoverflow.com/questions/37796287/convert-decimal-to-hex-in-lua-4
--- Shade Color generate
--- @param color string hex color
--- @param percent number
--- @return string
tools.shade_color = function(color, percent)
  local r, g, b = hex_to_rgb(color)

  -- If any of the colors are missing return "NONE" i.e. no highlight
  if not r or not g or not b then return "NONE" end

  r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
  g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
  b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
  r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

  return "#" .. string.format("%02x%02x%02x", r, g, b)
end


---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param grp string
---@param attr string?
--- @return string
tools.get_hl_grp_rgb = function(grp, attr)
  ---@param opts {name: string?, link: boolean?}?
  ---@param ns integer?
  local function get_hl_as_hex(opts, ns)
    opts, ns = opts or {}, ns or 0
    opts.link = opts.link ~= nil and opts.link or false
    local hl = vim.api.nvim_get_hl(ns, opts)

    hl.fg = hl.fg and ('#%06x'):format(hl.fg)
    hl.bg = hl.bg and ('#%06x'):format(hl.bg)

    return hl
  end

  assert(grp, 'Cannot get a highlight without specifying a group name')
  local hl_tbl = get_hl_as_hex({ name = grp })

  local hex_color = hl_tbl[attr]
  if not hex_color then
    vim.schedule(function()
      local msg = string.format(
        'Failed to get attribute \"%s\" for \"%s\" highlight group\n%s',
        attr,
        grp,
        debug.traceback()
      )

      vim.notify(msg, vim.log.levels.ERROR)
    end)

    return 'NONE'
  end

  return hex_color
end
