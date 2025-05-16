return {
  "echasnovski/mini.icons",
  version = false,
  config = function()
    local mini = require("mini.icons")

    local make_icon_tbl = function(category)
      local res = {}
      local postfix = "  "

      -- get list of keys, access keys, modify them, then store and return
      -- output format: key = { glyph = "" }
      for _, name in ipairs(mini.list(category)) do
        res[name] = { glyph = " " .. mini.get(category, name) .. postfix }
      end

      return res
    end

    local file_icon = { glyph = "   " }

    local defaults = make_icon_tbl("default")
    defaults["extension"] = file_icon
    defaults["file"] = file_icon
    defaults["filetype"] = file_icon

    mini.setup({
      default = defaults,
      directory = make_icon_tbl("directory"),
      extension = make_icon_tbl("extension"),
      -- https://github.com/echasnovski/mini.nvim/issues/1384
      file = {
        [".zshrc"] = { glyph = " 󰒓 " },
        ["init.lua"] = { glyph = " 󰢱  ", hl = "MiniIconsAzure" },
        ["README.md"] = { glyph = " 󰍔  ", hl = "MiniIconsCyan" },
        ["lazy"] = file_icon,
      },
      filetype = make_icon_tbl("filetype"),
      lsp = make_icon_tbl("lsp"),
    })
  end,
}
