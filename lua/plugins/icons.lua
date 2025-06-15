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

    local file_icons = make_icon_tbl("file")
    file_icons[".zshrc"] = { glyph = " 󰒓  " }
    file_icons["init.lua"] = { glyph = " 󰢱  ", hl = "MiniIconsAzure" }
    file_icons["README.md"] = { glyph = "   ", hl = "MiniIconsCyan" }
    file_icons["lazy"] = file_icon

    local ft_icons = make_icon_tbl("filetype")
    ft_icons["c"] = { glyph = "   "}
    ft_icons["cpp"] = { glyph = "   "}
    ft_icons["yaml"] = { glyph = "   "}

    mini.setup({
      default = defaults,
      directory = make_icon_tbl("directory"),
      extension = make_icon_tbl("extension"),
      -- https://github.com/echasnovski/mini.nvim/issues/1384
      file = file_icons,
      filetype = ft_icons,
      lsp = make_icon_tbl("lsp"),
    })
  end,
}
