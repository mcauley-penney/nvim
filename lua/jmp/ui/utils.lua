local M = {
	--- get rgb str from highlight group name
	--- @tparam  hi: highlight group name, e.g. Special
	--- @tparam  type: background or foreground
	get_hl_grp_rgb = function(grp, type)
		local hlID = vim.api.nvim_get_hl_id_by_name(grp)

		return vim.fn.synIDattr(hlID, type, "gui")
	end,

	make_hl_grp = function(grp_name, hi)
		vim.api.nvim_set_hl(0, grp_name, hi)

		return table.concat({ "%#", grp_name, "#" }, "")
	end,
}

return M
