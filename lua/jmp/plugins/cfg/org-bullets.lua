require("org-bullets").setup {
	concealcursor = true,
	symbols = {
		headlines = { "➤" },
		checkboxes = {
			half = { "", "OrgTSCheckboxHalfChecked" },
			done = { "✓", "OrgDone" },
			todo = { "✘", "OrgTODO" },
		},
	}
}
