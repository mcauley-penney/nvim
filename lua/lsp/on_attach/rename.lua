local M = {}

--- Wrapper around lsp rename that echoes instances of renaming.
-- Original: https://www.reddit.com/r/neovim/comments/um3epn/what_are_your_prizedfavorite_lua_functions/i8140hi/?utm_source=share&utm_medium=ios_app&utm_name=iossmf&context=3
-- Credit: Rafat913
M.rename = function()
	local curr_name = vim.fn.expand("<cword>")
	local opts = {
		prompt = "Rename: ",
		default = curr_name,
	}

	local on_confirm_fn = function(new_name)
		-- returns a table containing the lsp changes counts from an lsp result
		local function count_lsp_res_changes(lsp_res)
			local count = { instances = 0, files = 0 }

			if lsp_res.documentChanges then
				for _, changed_file in pairs(lsp_res.documentChanges) do
					count.files = count.files + 1
					count.instances = count.instances + #changed_file.edits
				end
			elseif lsp_res.changes then
				for _, changed_file in pairs(lsp_res.changes) do
					count.files = count.files + 1
					count.instances = count.instances + #changed_file
				end
			else
				vim.notify("Cannot count rename changes!")
			end

			return count
		end

		-- check new_name is valid
		if not new_name or #new_name == 0 or curr_name == new_name then
			return
		end

		-- request lsp rename
		local params = vim.lsp.util.make_position_params()
		params.newName = new_name

		vim.lsp.buf_request(
			0,
			"textDocument/rename",
			params,
			function(_, res, ctx, _)
				if not res then return end

				-- apply renames
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				if not client then return end

				vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

				-- get changes made by rename operation
				local changes = count_lsp_res_changes(res)

				-- display a message
				local msg = string.format(
					"%s renamed in %s file%s",
					changes.instances,
					changes.files,
					changes.files > 1 and "s. To save them run ':wa'" or ""
				)

				vim.notify(msg)
			end
		)
	end

	-- ask user input
	vim.ui.input(opts, on_confirm_fn)
end

return M
