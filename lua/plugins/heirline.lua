return {
  --  "rebelot/heirline.nvim",
  --  config = function()
  --    if not pcall(require, 'heirline') then return end

  --    local os_sep = package.config:sub(1, 1)
  --    local api = vim.api
  --    local fn = vim.fn
  --    local bo = vim.bo

  --    local conditions = require('heirline.conditions')
  --    local utils = require("heirline.utils")

  --    local devicons = require('nvim-web-devicons')

  --    local colors = {
  --      white = utils.get_highlight("Normal").fg,
  --      blue = utils.get_highlight("DiagnosticInfo").fg,
  --      dark = utils.get_highlight("CursorLine").bg,
  --      gray = utils.get_highlight("NonText").fg,
  --      green = utils.get_highlight("DiagnosticOk").fg,
  --      red = utils.get_highlight("DiagnosticError").fg,
  --      yellow = utils.get_highlight("DiagnosticWarn").fg,
  --    }
  --    require("heirline").load_colors(colors)

  --    local norm_icons = tools.ui.icons

  --    local priority = {
  --      CurrentPath = 60,
  --      Git = 40,
  --      WorkDir = 40,
  --      Lsp = 10,
  --    }

  --    local align = { provider = '%=' }
  --    local null = { provider = '' }
  --    local space = setmetatable({ provider = ' ' }, {
  --      __call = function(_, n)
  --        return { provider = string.rep(' ', n) }
  --      end
  --    })
  --    local read_only = {
  --      condition = function() return not bo.modifiable or bo.readonly end,
  --      provider = norm_icons.lock,
  --      hl = { fg = "yellow" }
  --    }
  --    local left_cap = {
  --      provider = '▌',
  --      hl = { fg = "dark" }
  --    }
  --    local file_node_icon = {
  --      provider = ' ' .. norm_icons.file .. ' ',
  --      hl = { fg = "gray" }
  --    }
  --    local branch_icon = {
  --      condition = conditions.is_git_repo,
  --      provider = ' ' .. norm_icons.branch .. ' ',
  --      hl = { fg = "green" }
  --    }

  --    local git
  --    do
  --      local git_remote = {
  --        condition = conditions.is_git_repo,
  --        init = function(self)
  --          self.git_status = vim.b.gitsigns_status_dict
  --        end,
  --        hl = "green",
  --        provider = function(self)
  --          local fname = vim.api.nvim_buf_get_name(0)
  --          local root = tools.get_path_root(fname)
  --          local remote = tools.get_git_remote_name(root)
  --          local branch = tools.get_git_branch(root)

  --          if remote and branch then
  --            return table.concat { remote, ':', branch }
  --          end
  --        end,
  --      }

  --      git = { branch_icon, git_remote, space }
  --    end

  --    local fname_block, cur_path, file_name
  --    do
  --      local file_icon = {
  --        condition = function()
  --          return not read_only.condition()
  --        end,
  --        init = function(self)
  --          local filename = self.filename
  --          local extension = fn.fnamemodify(filename, ':e')
  --          self.icon, self.icon_color = devicons.get_icon_color(
  --            filename, extension, { default = true })
  --        end,
  --        provider = function(self)
  --          if self.icon then return self.icon .. ' ' end
  --        end,
  --        hl = function(self)
  --          return { fg = self.icon_color }
  --        end
  --      }

  --      local work_dir = {
  --        hl = { fg = "gray" },
  --        flexible = priority.WorkDir,
  --        {
  --          provider = function(self)
  --            local fname = vim.api.nvim_buf_get_name(0)

  --            return table.concat({ fname })
  --          end
  --        },
  --        null
  --      }

  --      file_name = {
  --        provider = function(self) return self.filename end,
  --      }

  --      fname_block = {
  --        { file_node_icon, space(2), file_icon, file_name },
  --        { provider = '%<' },
  --      }
  --    end

  --    --------------------------------------------------------------------------------

  --    local file_properties = {
  --      condition = function(self)
  --        self.filetype = bo.filetype

  --        local encoding = (bo.fileencoding ~= '' and bo.fileencoding) or vim.o.encoding
  --        self.encoding = (encoding ~= 'utf-8') and encoding or nil

  --        local fileformat = bo.fileformat

  --        -- if fileformat == 'dos' then
  --        --    fileformat = ' '
  --        -- elseif fileformat == 'mac' then
  --        --    fileformat = ' '
  --        -- else  -- unix'
  --        --    fileformat = ' '
  --        --    -- fileformat = nil
  --        -- end

  --        if fileformat == 'dos' then
  --          fileformat = 'CRLF'
  --        elseif fileformat == 'mac' then
  --          fileformat = 'CR'
  --        else -- 'unix'
  --          -- fileformat = 'LF'
  --          fileformat = ""
  --        end

  --        self.fileformat = fileformat

  --        return self.fileformat or self.encoding
  --      end,
  --      provider = function(self)
  --        local sep = (self.fileformat and self.encoding) and ' ' or ''
  --        return table.concat { ' ', self.fileformat or '', sep, self.encoding or '', ' ' }
  --      end,
  --      --  hl = hl.FileProperties,
  --    }

  --    local diagnostics = {
  --      condition = tools.diagnostics_available(),
  --      static = {
  --        error_icon = norm_icons.ballot_x,
  --        warn_icon  = norm_icons.up_tri,
  --        info_icon  = norm_icons.info_i,
  --        hint_icon  = norm_icons.info_i,
  --      },
  --      init = function(self)
  --        self.errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  --        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  --        self.hints    = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  --        self.info     = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  --      end,
  --      {
  --        {
  --          provider = function(self) return self.error_icon .. ' ' end,
  --          hl = { fg = "red" },
  --        },
  --        {
  --          provider = function(self) return self.errors .. '  ' end,
  --        }
  --      },
  --      {
  --        {
  --          provider = function(self) return self.warn_icon .. ' ' end,
  --          hl = { fg = "yellow" },
  --        },
  --        {
  --          provider = function(self) return self.warnings .. '  ' end,
  --        }
  --      },
  --      space(2)
  --    }



  --    local search_results = {
  --      condition = function(self)
  --        local lines = api.nvim_buf_line_count(0)
  --        if lines > 50000 then return end

  --        local query = fn.getreg("/")
  --        if query == "" then return end

  --        if query:find("@") then return end

  --        local search_count = fn.searchcount({ recompute = 1, maxcount = -1 })
  --        local active = false
  --        if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
  --          active = true
  --        end
  --        if not active then return end

  --        query = query:gsub([[^\V]], "")
  --        query = query:gsub([[\<]], ""):gsub([[\>]], "")

  --        self.query = query
  --        self.count = search_count
  --        return true
  --      end,
  --      {
  --        provider = function(self)
  --          return table.concat {
  --            -- ' ', self.query, ' ', self.count.current, '/', self.count.total, ' '
  --            ' ', self.count.current, '/', self.count.total, ' '
  --          }
  --        end,
  --        --  hl = hl.SearchResults
  --      },
  --      space
  --    }

  --    local scrollbar = {
  --      static = {
  --        sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  --      },
  --      provider = function(self)
  --        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  --        local lines = vim.api.nvim_buf_line_count(0)
  --        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
  --        return string.rep(self.sbar[i], 2)
  --      end,
  --      hl = { fg = "blue", bg = "dark" },
  --    }

  --    --------------------------------------------------------------------------------

  --    local HelpBufferStatusline = {
  --      condition = function()
  --        return bo.filetype == "help"
  --      end,
  --      space,
  --      {
  --        provider = function()
  --          local filename = api.nvim_buf_get_name(0)
  --          return fn.fnamemodify(filename, ":t")
  --        end,
  --        --  hl = hl.FileName
  --      },
  --      align,
  --      scrollbar
  --    }

  --    local StatusLines = {
  --      init = function(self)
  --        local pwd = fn.getcwd(0) -- Present working directory.
  --        local current_path = api.nvim_buf_get_name(0)
  --        local filename

  --        if current_path == "" then
  --          pwd = fn.fnamemodify(pwd, ':~')
  --          current_path = ""
  --          filename = ' [No Name]'
  --        elseif current_path:find(pwd, 1, true) then
  --          filename = fn.fnamemodify(current_path, ':t')
  --          current_path = fn.fnamemodify(current_path, ':~:.:h')
  --          pwd = fn.fnamemodify(pwd, ':~') .. os_sep
  --          if current_path == '.' then
  --            current_path = ""
  --          else
  --            current_path = current_path .. os_sep
  --          end
  --        else
  --          pwd = ""
  --          filename = fn.fnamemodify(current_path, ':t')
  --          current_path = fn.fnamemodify(current_path, ':~:.:h') .. os_sep
  --        end

  --        self.pwd = pwd
  --        self.current_path = current_path -- The opened file path relevant to pwd.
  --        self.filename = filename
  --      end,
  --      {
  --        left_cap,
  --        space,
  --        git,
  --        {
  --          fallthrough = false,
  --          { fname_block, }
  --        },
  --        align,
  --        diagnostics,
  --        file_properties,
  --        search_results,
  --        scrollbar
  --      }
  --    }

  --    require('heirline').setup({ statusline = StatusLines })
  --  end
}
