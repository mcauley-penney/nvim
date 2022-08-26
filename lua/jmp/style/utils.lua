local M = {
  --- get rgb str from highlight group name
  --- @tparam  hi: highlight group name, e.g. Special
  --- @tparam  type: background or foreground
  get_hl_grp_rgb = function(grp, type)
    local _get_hl_rgb_str = function(hl_num)
      return string.format("#%06x", hl_num)
    end

    -- retrieve table of hi info
    local hl_tbl = vim.api.nvim_get_hl_by_name(grp, true)

    if type == "fg" then
      return _get_hl_rgb_str(hl_tbl.foreground)
    elseif type == "bg" then
      return _get_hl_rgb_str(hl_tbl.background)
    end
  end,

  make_hl_grp = function(grp, hi)
    vim.api.nvim_set_hl(0, grp, hi)

    return table.concat({ "%#", grp, "#" }, "")
  end,
}

return M
