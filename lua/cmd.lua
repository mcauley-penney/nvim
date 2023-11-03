-- Copy the current file path to the clipboard
-- Original: monkoose
-- https://www.reddit.com/r/neovim/comments/u221as/comment/i4g4r8b/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})


vim.api.nvim_create_user_command("Preview", "! xdg-open %", { bang = true })
