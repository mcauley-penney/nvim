-- api docs: https://neovim.io/doc/user/api.html

local str = {
  c_sl = "// ",
  dash = "-- ",
  latx = "% ",
  md = "* ",
  semi = ";; ",
  text = "- ",
  octo = "# ",
}

local ft_match_table = {
  ["c"] = str.c_sl,
  ["cpp"] = str.c_sl,
  ["css"] = "/*  */",
  ["cuda"] = str.c_sl,
  ["gitcommit"] = str.text,
  ["gitconfig"] = str.octo,
  ["javascript"] = str.c_sl,
  ["lisp"] = str.semi,
  ["lua"] = str.dash,
  ["make"] = str.octo,
  ["markdown"] = str.md,
  ["org"] = str.octo,
  ["python"] = str.octo,
  ["sh"] = str.octo,
  ["tex"] = str.latx,
  ["txt"] = str.text,
  ["text"] = str.text,
  ["vim"] = '" ',
  ["yaml"] = str.octo,
}

local M = {
  -- Send comments to buffer at cursor position.
  send_comment = function()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")

    return ft_match_table[ft]
  end,
}

return M
