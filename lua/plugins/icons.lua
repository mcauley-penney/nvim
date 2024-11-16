return {
  'echasnovski/mini.icons',
  version = false,
  config = function()
    local mini = require("mini.icons")

    local make_icon_tbl = function(category, postfix)
      local res = {}
      postfix = postfix or " "

      -- get list of keys, access keys, modify them, then store and return
      -- output format: key = { glyph = "" }
      for _, name in ipairs(mini.list(category)) do
        res[name] = { glyph = " " .. mini.get(category, name) .. postfix }
      end

      return res
    end

    mini.setup({
      default   = make_icon_tbl("default"),
      directory = make_icon_tbl("directory"),
      extension = make_icon_tbl("extension"),
      file      = make_icon_tbl("file"),
      filetype  = make_icon_tbl("filetype", "  "),
      lsp       = make_icon_tbl("lsp")
    })
  end
}