return {
	{
		"windwp/nvim-autopairs",
		config = {
			break_undo = true,
			check_ts = false,
			disable_in_macro = true,
			disable_in_replace_mode = false,
			disable_in_visualblock = false,
			enable_abbr = false,
			enable_afterquote = false,
			enable_bracket_in_quote = false,
			enable_check_bracket_line = true,
			enable_moveright = false,
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			map_bs = true,
			map_c_h = true,
			map_c_w = false,
			map_cr = true,
			fast_wrap = {
				map = '<C-w>',
			}
		}
	}
}
