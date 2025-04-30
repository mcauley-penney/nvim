return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local set_hl = vim.api.nvim_set_hl

    local red = "DiagnosticError"
    local ylw = "DiagnosticWarn"
    local add_sym = '┃'
    local change_sym = '┃'
    local del_sym = '┃'

    local sign_tbl = {}
    local dim_hl, fg
    for grp, cfg in pairs({
      Add = { "DiagnosticOk", add_sym },
      Change = { ylw, change_sym },
      Changedelete = { ylw, change_sym },
      Delete = { red, del_sym },
      Topdelete = { red, del_sym },
    }) do
      fg = tools.get_hl_hex({ name = cfg[1] })["fg"]
      dim_hl = tools.tint(fg, -25)
      set_hl(0, "GitSigns" .. grp, { fg = dim_hl })

      sign_tbl[string.lower(grp)] = { text = cfg[2] }
    end

    set_hl(0, "GitSignsUntracked", { link = "NonText" })
    sign_tbl["untracked"] = { text = add_sym }


    local diffadd_bg = tools.get_hl_hex({ name = "DiffAdd" })["bg"]
    local diffrm_bg = tools.get_hl_hex({ name = "DiffDelete" })["bg"]
    local diffadd_lighter = tools.tint(diffadd_bg, 75)
    local diffrm_lighter = tools.tint(diffrm_bg, 75)

    set_hl(0, "GitSignsAddInline", { link = "DiffAdd" })
    set_hl(0, "GitSignsAddLnInline", { fg = "fg", bg = diffadd_lighter })
    set_hl(0, "GitSignsChangeInline", { link = "DiffText" })
    set_hl(0, "GitSignsChangeLnInline", { link = "DiffChange" })
    set_hl(0, "GitSignsDeleteInline", { link = "DiffDelete" })
    set_hl(0, "GitSignsDeleteLnInline", { fg = "fg", bg = diffrm_lighter })

    require("gitsigns").setup({
      attach_to_untracked = false,
      preview_config = {
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      signs = sign_tbl,
      signcolumn = true,
      update_debounce = 500,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gb', function() gs.blame_line({ full = false }) end)
        map('n', '<leader>gd', gs.diffthis)
        map('n', '<leader>gD', function() gs.diffthis('~') end)
        map("n", "<leader>gt", gs.toggle_signs)
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hu", gs.undo_stage_hunk)

        map({ "n", "v" }, "<leader>hs", ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')

        for map_str, fn in pairs({
          ["]h"] = gs.next_hunk,
          ["[h"] = gs.prev_hunk
        }) do
          map('n', map_str, function()
            if vim.wo.diff then return map_str end
            vim.schedule(function() fn() end)
            return '<Ignore>'
          end, { expr = true })
        end
      end
    })
  end
}
