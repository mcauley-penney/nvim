return {
	{
		"nvim-orgmode/orgmode",
		config = function()
			local files = "/home/m/files/kms/gtd/"
			local icons = tools.ui.icons

			require('orgmode').setup_ts_grammar()

			require('orgmode').setup({
				org_agenda_files = files .. "agenda/*",
				org_archive_location = files .. "archive.org",
				org_capture_templates = {
					t = { description = 'Task', template = '* TODO %?\n  %U' },
				},
				org_default_notes_file = files .. "inbox.org",
				org_ellipsis = table.concat({ " ", icons["ellipses"], " " }),
				org_hide_leading_stars = true,
				org_indent = "noindent",
				org_log_done = "time",
				org_todo_keywords = { "TODO(t)", "BLOCKED", "WAITING", '|', "DONE" },

				win_split_mode = "below 35split",

				mappings = {
					org = {
						org_timestamp_up_day = '<up>',
						org_timestamp_down_day = '<down>'
					}
				},
			})

			vim.api.nvim_set_hl(0, "OrgAgendaScheduled", { link = "Normal" })
			vim.api.nvim_set_hl(0, "OrgDONE", { link = "DiagnosticOk" })
			vim.api.nvim_set_hl(0, "OrgDONE_builtin", { link = "DiagnosticOk" })
			vim.api.nvim_set_hl(0, "OrgTSCheckbox", { link = "Visual" })
			vim.api.nvim_set_hl(0, "OrgTSCheckboxChecked", { link = "DiagnosticOk" })
			vim.api.nvim_set_hl(0, "OrgTSCheckboxHalfChecked", { link = "DiagnosticError" })
			vim.api.nvim_set_hl(0, "org_hyperlink", { link = "Visual" })

			local grp = vim.api.nvim_create_augroup("org", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = "org",
				callback = function()
					vim.api.nvim_set_option_value("foldenable", false, {})
					vim.api.nvim_set_option_value("conceallevel", 2, {})
				end
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = "orgagenda",
				command = "set textwidth=0"
			})
		end,
	}
}
