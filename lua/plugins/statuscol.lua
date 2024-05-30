local function get_lnum()
  local cur_num
  local sep = ','

  -- return a visual placeholder if line is wrapped
  if vim.v.virtnum ~= 0 then return '│' end

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

  return require("ui.utils").pad_str(cur_num, 3, "right")
end

return {
  "luukvbaal/statuscol.nvim",
  -- TODO: remove when 0.10 is latest release
  branch = "0.10",
  config = function()
    require("statuscol").setup({
      ft_ignore = {
        "aerial",
        "help",
        "neo-tree",
        "toggleterm",
      },
      segments = {
        { text = { ' ' } },
        {
          sign = {
            namespace = { "diagnostic" },
            colwidth = 1,
          },
          condition = {
            function()
              return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) and
                  tools.diagnostics_available()
            end
          }
        },
        { text = { "%=", get_lnum, " " } },
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
          },
          condition = {
            function()
              local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
              return tools.get_git_remote_name(root)
            end
          }
        },
        {
          text = { require("statuscol.builtin").foldfunc },
          condition = {
            function()
              return vim.api.nvim_get_option_value("modifiable", { buf = 0 })
            end
          }
        },
        { text = { " " }, hl = "Normal" }
      }
    })
  end
}
