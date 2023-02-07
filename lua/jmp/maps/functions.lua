-- api docs: https://neovim.io/doc/user/api.html

local ft_cstr_overrides = {
	["gitcommit"] = "- ",
	["org"] = "- ",
	["txt"] = "- ",
	["text"] = "- "
}


local unwrap_cstr = function(cstr)
	local left, right = string.match(cstr, '(.*)%%s(.*)')

	return vim.trim(left), vim.trim(right)
end

local M = {
	send_comment = function()
		local ft = vim.api.nvim_buf_get_option(0, "filetype")
		local cstr = ft_cstr_overrides[ft]
		if (cstr ~= nil) then return cstr end

		local row, col
		local pos_tbl = vim.api.nvim_win_get_cursor(0)

		row = pos_tbl[1] - 1
		col = pos_tbl[2]

		cstr = vim.bo.commentstring

		local lcs, rcs = unwrap_cstr(cstr)
		local inc_len = string.find(cstr, "%s*%%s") - 1

		vim.schedule(function()
			vim.api.nvim_buf_set_text(0, row, col, row, col, { lcs .. ' ' .. rcs })
			vim.api.nvim_win_set_cursor(0, { row + 1, col + inc_len + 1 })
		end)
	end,
}

return M
