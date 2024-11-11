local function get_num_wraps()
  -- Calculate the actual buffer width, accounting for splits, number columns, and other padding
  local wrapped_lines = vim.api.nvim_win_call(0, function()
    local winid = vim.api.nvim_get_current_win()

    local winfo = vim.fn.getwininfo(winid)[1]
    local bufwidth = winfo["width"] - winfo["textoff"]
    local line_length = vim.fn.strdisplaywidth(vim.fn.getline(vim.v.lnum))

    return math.floor(line_length / bufwidth)
  end)

  return wrapped_lines
end

return {
  "luukvbaal/statuscol.nvim",
  config = function()
    require("statuscol").setup({
      relculright = true,
      thousands = ',',
      ft_ignore = {
        "aerial",
        "help",
        "neo-tree",
        "toggleterm",
      },
      segments = {
        {
          sign = {
            namespace = { "diagnostic" },
          },
          condition = {
            function()
              return tools.diagnostics_available() or '  '
            end
          }
        },
        {
          condition = {
            function()
              return vim.wo.number or vim.wo.relativenumber
            end
          },
          text = {
            ' ',
            "%=",
            function(args)
              if vim.v.virtnum == 0 then
                return require("statuscol.builtin").lnumfunc(args)
              elseif vim.v.virtnum < 0 then
                return '-'
              else
                local num_wraps = get_num_wraps()
                local hl = vim.api.nvim_win_get_cursor(0)[1] == vim.v.lnum and "CursorLineNr" or "LineNr"

                if vim.v.virtnum == num_wraps then
                  return tools.hl_str(hl, '└')
                else
                  return tools.hl_str(hl, '├')
                end
              end
            end,
            ' ',
          }
        },
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
          },
          condition = {
            function()
              local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
              return tools.get_git_remote_name(root) or ' '
            end
          }
        },
        { text = { " " }, hl = "Normal" },
        {
          text = { require("statuscol.builtin").foldfunc },
          condition = {
            function()
              return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) or ' '
            end
          }
        },
        { text = { " " }, hl = "Normal" }
      }
    })
  end
}
