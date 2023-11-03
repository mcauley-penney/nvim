local function get_lnum()
  local cur_num
  local sep = ','

  -- return a visual placeholder if line is wrapped
  if vim.v.virtnum ~= 0 then return '-' end

  -- get absolute lnum if is current line, else relnum
  cur_num = vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum

  -- insert thousands separators in line numbers
  -- viml regex: https://stackoverflow.com/a/42911668
  -- lua pattern: stolen from Akinsho
  if cur_num > 999 then
    cur_num = tostring(cur_num):reverse():gsub('(%d%d%d)', '%1' .. sep):reverse():gsub('^,', '')
  else
    cur_num = tostring(cur_num)
  end

  local utils = require("ui.utils")
  return utils.pad_str(cur_num, 3, "right")
end

return {
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        segments = {
          { sign = { name = { "Diagnostic" }, maxwidth = 1 } },
          { text = { "%=", get_lnum, " " } },
          { sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 1 } },
          { text = { " ", builtin.foldfunc, " " } },
        }
      })
    end
  },
}
