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
            ' ',
            "%=",
            function(args)
              local mode = vim.fn.mode()
              local normed_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

              local line = require("statuscol.builtin").lnumfunc(args)
              -- get character for cur line
              if normed_mode ~= 'v' and args.virtnum == 0 then
                return line
              end

              if args.virtnum < 0 then
                return '-'
              end

              local num_wraps = vim.api.nvim_win_text_height(args.win, {
                start_row = args.lnum - 1,
                end_row = args.lnum - 1,
              })["all"]

              if args.virtnum > 0 then
                line = args.virtnum == num_wraps - 1 and '└' or '├'
              end

              local e_row = vim.fn.line('.')

              -- if the line is wrapped and we are not in visual mode
              if normed_mode ~= 'v' then
                return e_row == args.lnum and
                    tools.hl_str("CursorLineNr", line) or
                    tools.hl_str("LineNr", line)
              end

              local s_row = vim.fn.line('v')
              local normed_s_row, normed_e_row = swap(s_row, e_row)

              -- if the line number is outside our visual selection
              if args.lnum < normed_s_row or args.lnum > normed_e_row then
                return tools.hl_str("LineNr", line)
              end

              -- if the line number is visually selected and not wrapped
              if args.virtnum == 0 and num_wraps == 1 then
                return tools.hl_str("CursorLineNr", line)
              end

              -- if the line is visually selected and wrapped, only highlight selected screen lines
              local buf_width = get_buf_width()
              local vis_start_wrap = math.floor((vim.fn.virtcol('v') - 1) / buf_width)
              local vis_end_wrap = math.floor((vim.fn.virtcol('.') - 1) / buf_width)
              local normed_vis_start_wrap, normed_vis_end_wrap = swap(vis_start_wrap, vis_end_wrap)

              if normed_s_row < args.lnum and (args.virtnum <= normed_vis_end_wrap or normed_e_row > args.lnum) then
                return tools.hl_str("CursorLineNr", line)
              end

              if normed_s_row == args.lnum and
                  (normed_e_row == args.lnum and args.virtnum >= normed_vis_start_wrap and args.virtnum <= normed_vis_end_wrap) or
                  (normed_e_row > args.lnum and args.virtnum >= vis_end_wrap) then
                return tools.hl_str("CursorLineNr", line)
              end

              return tools.hl_str("LineNr", line)
            end,
            ' ',
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
          text = { " " }
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
          text = { " " }
        }
      }
    })
  end
}
