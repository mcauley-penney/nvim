local files = "/home/m/files/kms/gtd/"
local ui = require("jmp.ui")
local icons = ui["no_hl_icons"]


require('orgmode').setup({
	org_agenda_files = files .. "lists/*",
	org_archive_location = files .. "archive.org",
	org_capture_templates = {
		t = { description = 'Task', template = '* TODO %?\n  %U' }
	},
	org_default_notes_file = files .. "inbox.org",
	org_ellipsis = table.concat({ " ", icons["fold"], " " }),
	org_todo_keywords = { "TODO(t)", "BLOCKED", "WAITING", '|', "DONE" },


	notifications = {
		enabled = true,
		reminder_time = { 5, 15, 30 },
		notifier = function(tasks)
			for _, task in ipairs(tasks) do
				local title = string.format('%s (%s)', task.category, task.humanized_duration)
				local subtitle = string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title)
				local date = string.format('%s: %s', task.type, task.time:to_string())
				vim.loop.spawn('notify-send', { args = { string.format('%s\n%s\n%s', title, subtitle, date) } })
			end
		end,
	},

	win_split_mode = "below 30split"
})

local grp = vim.api.nvim_create_augroup("org", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = grp,
	pattern = "org",
	command = "set conceallevel=2"
})

-- https://github.com/nvim-orgmode/orgmode/issues/433
vim.api.nvim_create_autocmd("FileType", {
	group = grp,
	pattern = "orgagenda",
	command = "set signcolumn=no"
})

require('orgmode').setup_ts_grammar()
