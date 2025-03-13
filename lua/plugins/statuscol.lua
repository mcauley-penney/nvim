local function get_buf_width()
  local win_id = vim.api.nvim_get_current_win()
  local win_info = vim.fn.getwininfo(win_id)[1]
  return win_info["width"] - win_info["textoff"]
end

local function swap(start_val, end_val)
  if start_val > end_val then
    local swap_val = start_val
    start_val = end_val
    end_val = swap_val
  end

  return start_val, end_val
end

local function get_numcol_text(args, num_wraps)
  local line = require("statuscol.builtin").lnumfunc(args)

  if args.virtnum > 0 then
    line = args.virtnum == num_wraps and '└' or '├'
  end

  return line
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
              return tools.diagnostics_available() or ' '
            end
          }
        },
        {
          text = { ' ' }
        },
        {
          text = {
            "%=",
            function(args)
              if args.virtnum < 0 then
                return '-'
              end

              local num_wraps = vim.api.nvim_win_text_height(args.win, {
                start_row = args.lnum - 1,
                end_row = args.lnum - 1,
              })["all"] - 1

              local e_row = vim.fn.line('.')

              local text = get_numcol_text(args, num_wraps)

              local is_visual = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "") == 'v'
              if not is_visual then
                if args.virtnum == 0 then
                  return require("statuscol.builtin").lnumfunc(args)
                end

                return e_row == args.lnum and
                    tools.hl_str("CursorLineNr", text) or
                    tools.hl_str("LineNr", text)
              end

              local s_row
              s_row, e_row = swap(vim.fn.line('v'), e_row)

              -- if the line number is outside our visual selection
              if args.lnum < s_row or args.lnum > e_row then
                return tools.hl_str("LineNr", text)
              end

              -- if the line is visually selected and not wrapped
              if num_wraps == 0  or (s_row < args.lnum and args.lnum < e_row) then
                return tools.hl_str("CursorLineNr", text)
              end

              -- Here, the line is visually selected and wrapped
              local buf_width = get_buf_width()
              local start_wrap = math.floor((vim.fn.virtcol('v') - 1) / buf_width)
              local end_wrap = math.floor((vim.fn.virtcol('.') - 1) / buf_width)

              if start_wrap == 0 and args.lnum < e_row then
                start_wrap = end_wrap
                end_wrap = num_wraps
              end

              if start_wrap <= args.virtnum and args.virtnum <= end_wrap then
                return tools.hl_str("CursorLineNr", text)
              end

              return tools.hl_str("LineNr", text)
            end,
            ' '
          },
          condition = {
            function()
              return vim.wo.number or vim.wo.relativenumber
            end
          },
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
        {
          text = { ' ' }
        },
        {
          text = { require("statuscol.builtin").foldfunc },
          condition = {
            function()
              return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) or ' '
            end
          }
        },
        {
          text = { ' ' }
        }
      }
    })
  end
}
