-- api docs: https://neovim.io/doc/user/api.html

local ft_cstr_overrides = {
	["gitcommit"] = "- ",
	["txt"] = "- ",
	["text"] ="- "
}


local unwrap_cstr = function(cstr)
	local left, right = string.match(cstr, '(.*)%%s(.*)')

	return vim.trim(left), vim.trim(right)
end

local find_cstr_cursor_pos = function(cstr)
	-- if there is a space before the cursor position, do not
	-- include it in the length we are calculating by adding
	-- '%s*'
	local start = string.find(cstr, "%s*%%s")

	return start - 1
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

		local lcs, rcs = unwrap_cstr(vim.bo.commentstring)
		local inc_len = find_cstr_cursor_pos(vim.bo.commentstring)

		vim.schedule(function()
			vim.api.nvim_buf_set_text(0, row, col, row, col, { lcs .. ' ' .. rcs })
			vim.api.nvim_win_set_cursor(0, { row + 1, col + inc_len + 1 })
		end)
	end,
}

return M
