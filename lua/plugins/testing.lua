return {
  -- https://www.reddit.com/r/vim/comments/k10psl/how_to_convert_smart_quotes_and_other_fancy/
  --  "idbrii/vim-textconv",

  {
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = "DocsViewToggle",
    opts = {
      position = "bottom",
      width = 60
    }
  },

  {
    "sindrets/diffview.nvim",
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function()
          local opt = vim.opt_local
          opt.wrap, opt.list, opt.relativenumber = false, false, false
        end,
      },
      config = function()
        --  vim.api.nvim_set_hl(0, "DiffviewStatusAdded", { link = 'DiffAddedChar' })
        --  vim.api.nvim_set_hl(0, "DiffviewStatusModified", { link = 'DiffChangedChar' })
        --  vim.api.nvim_set_hl(0, "DiffviewStatusRenamed", { link = 'DiffChangedChar' })
        --  vim.api.nvim_set_hl(0, "DiffviewStatusUnmerged", { link = 'DiffChangedChar' })
        --  vim.api.nvim_set_hl(0, "DiffviewStatusUntracked", { link = 'DiffAddedChar' })
      end
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_expanders = true,
          expander_collapsed = tools.ui.icons.r_chev,
          expander_expanded = tools.ui.icons.d_chev,
          expander_highlight = "NonText",
        },
        icon = {
          folder_closed = " ",
          folder_open = " ",
        },
        modified = {
          symbol = tools.ui.icons.bullet,
          highlight = "DiagnosticError",
        },
        name = {
          trailing_slash = true,
        },
      },
      filesystem = {
        hijack_netrw_behavior = 'open_current',
        use_libuv_file_watcher = true,
        group_empty_dirs = false,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { '.DS_Store' },
        },
        window = {
          mappings = {
            ["e"] = "noop",
            ['/'] = 'noop',
            ['g/'] = 'fuzzy_finder',
            ['<F1>'] = 'open'
          },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.cmd([[
            hi! link NeoTreeDirectoryName None
            hi! link NeoTreeDirectoryIcon Operator
            hi! link NeoTreeNormal NormalFloat
            hi! link NeoTreeNormalNC NormalFloat
            hi! link NeoTreeRootName Directory
          ]])
          end
        },
        {
          event = "neo_tree_popup_input_ready",
          handler = function()
            -- enter input popup with normal mode by default.
            vim.cmd("stopinsert")
          end,
        }
      },
      close_if_last_window = true,
      enable_git_status = false,
      enable_diagnostics = false,
      source_selector = {
        highlight_tab_active = "NormalFloat",
        winbar = true,                         -- toggle to show selector on winbar
        show_scrolled_off_parent_node = false, -- boolean
        sources = {                            -- table
          {
            source = "filesystem",
            display_name = " "
          },
        }
      }
    },
    init = function()
      local path = vim.api.nvim_buf_get_name(0)
      local root = tools.get_path_root(path)

      if root == nil then
        root = vim.fn.expand("%:h")
      end

      vim.api.nvim_create_user_command("Tree", "Neotree action=show reveal=true toggle=true dir=" .. root,
        { bang = true }
      )
    end
  },

  {
    'b0o/incline.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      window = {
        padding = 0,
        margin = {
          horizontal = 2,
          vertical = 2,
        },
        placement = {
          horizontal = 'center',
          vertical = 'bottom',
        },
      },
      render = function(props)
        local float_hl = tools.get_hl_hex({ name = "NormalFloat" })
        local norm_hl = tools.get_hl_hex({ name = "Normal" })

        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then
          filename = '[No Name]'
        end
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)

        return {
          { '', guibg = norm_hl.bg, guifg = float_hl.bg },
          ft_icon and { ft_icon .. ' ', guifg = ft_color } or {},
          filename,
          { '', guibg = norm_hl.bg, guifg = float_hl.bg },
        }
      end
    }
  },

  {
    "LunarVim/bigfile.nvim",
    opts = {
      features = {
        "illuminate",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
      },
    }
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- From docs
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local ellipses = tools.ui.icons.ellipses
        local newVirtText = {}
        local curWidth = 0

        local suffix = (" %s [%d lines] "):format(ellipses, endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end

          curWidth = curWidth + chunkWidth
        end

        table.insert(newVirtText, { '  ' })
        table.insert(newVirtText, { suffix, "Folded" })

        return newVirtText
      end

      require('ufo').setup({
        enable_get_fold_virt_text = true,
        fold_virt_text_handler = handler,
        open_fold_hl_timeout = 0,
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end
      })
    end,
  },

  {
    "mcauley-penney/autolist.nvim",
    ft = {
      "markdown",
      "plaintex",
      "tex",
      "text",
    },
    config = function()
      require("autolist").setup()

      vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")

      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "m<CR>", "o<cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "m<SPACE>", "O<cmd>AutolistNewBulletBefore<cr>")
      vim.keymap.set("n", "<C-Space>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      vim.keymap.set("n", "<leader>lr", "<cmd>AutolistRecalculate<cr>")

      -- cycle list types with dot-repeat
      vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
      vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

      -- functions to recalculate list on edit
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  {
    'lukas-reineke/headlines.nvim',
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "markdown", "org" },
    config = function()
      require("headlines").setup({
        markdown = {
          dash_string = "-",
          quote_string = "┃",
          fat_headlines = false,
          fat_headline_upper_string = "▃",
          fat_headline_lower_string = "🬂",
          bullets = {}
        },
        org = {
          fat_headlines = false,
          bullets = { '○' }
        },
      })

      vim.api.nvim_set_hl(0, "CodeBlock", { link = "markdownCodeBlock" })
    end
  },
}
