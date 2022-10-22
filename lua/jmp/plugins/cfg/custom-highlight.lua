local unused_handler = require('nvim-custom-diagnostic-highlight').setup {
	register_handler = true,
	handler_name = 'kasama/nvim-custom-diagnostic-highlight',
	highlight_group = 'CustomLSPUnused',
	patterns_override = {
		'%sunused', '^unused', 'not used', 'never used',
		'not read', 'never read', 'empty block', 'not accessed'
	},
	extra_patterns = {},
	diagnostic_handler_namespace = 'unused_hl_ns',
	defer_until_n_lines_away = false,
	defer_highlight_update_events = { 'CursorHold', 'CursorHoldI' },
}

vim.diagnostic.handlers['CustomLSP/unused'] = unused_handler
