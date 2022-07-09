local utils = require("jmp.style.utils")

local make_invisible_border = function()
  local border = {}
  local required_border_len = 8

  while #border < required_border_len do
    table.insert(border, { " ", "FloatBorder" })
  end

  return border
end

local make_lsp_palette = function()
  local get_hi = utils.get_hl_grp_rgb
  local palette = {}

  for _, sign_type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
    palette[sign_type] = get_hi("Diagnostic" .. sign_type, "fg")
  end

  palette["bg"] = get_hi("StatusLine", "bg")
  palette["Failure"] = get_hi("Comment", "fg")
  palette["Success"] = get_hi("__success", "fg")

  return palette
end

local make_lsp_palette_groups = function(palette)
  local hl_dict = {}
  local name

  for type, hex_str in pairs(palette) do
    hl_dict[type] = {}

    name = "UI" .. type

    hl_dict[type].name = name

    hl_dict[type].hl_str = utils.make_hl_grp({
      grp = name,
      fg = hex_str,
      bg = palette["bg"],
    })
  end

  return hl_dict
end

local style = {
  ["border"] = make_invisible_border(),
  ["palette"] = make_lsp_palette(),
  ["signs"] = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = "",
  },
  ["icons"] = {
    ["branch"] = "",
    ["mod"] = "•",
    ["ro"] = "",
  },
}

style["palette_grps"] = make_lsp_palette_groups(style["palette"])

return style
