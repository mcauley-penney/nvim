local files = "/home/m/files/kms/gtd/"
local ui = require("jmp.ui")
local icons = ui["no_hl_icons"]


require('orgmode').setup({
	org_agenda_files = files .. "agenda/*",
	org_archive_location = files .. "archive.org",
	org_capture_templates = {
		t = { description = 'Task', template = '* TODO %?\n  %U' }
	},
	org_default_notes_file = files .. "inbox.org",
	org_ellipsis = table.concat({ " ", icons["fold"], " " }),
	org_indent = "noindent",
	org_todo_keywords = { "TODO(t)", "BLOCKED", "WAITING", '|', "DONE" },

	win_split_mode = "below 30split"
})

-- TODO: turn off underlining for TSHeadlines
vim.api.nvim_set_hl(0, "OrgDONE", {link = "DiagnosticOk"})
vim.api.nvim_set_hl(0, "OrgDONE_builtin", {link = "DiagnosticOk"})
vim.api.nvim_set_hl(0, "OrgTSCheckbox", {link = "Normal"})

local grp = vim.api.nvim_create_augroup("org", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = grp,
	pattern = "org",
	callback = function()
		vim.api.nvim_win_set_option(0, "foldenable", false)
		vim.api.nvim_win_set_option(0, "conceallevel", 2)
	end
})

vim.api.nvim_create_autocmd("FileType", {
	group = grp,
	pattern = "orgagenda",
	command = "set textwidth=0"
})

require('orgmode').setup_ts_grammar()
