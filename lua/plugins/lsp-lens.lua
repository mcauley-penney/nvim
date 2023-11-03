
local function format(count, label)
	return string.format("%s %s%s", count, label, count > 1 and 's' or '')
end

return {
	"VidocqH/lsp-lens.nvim",
	lazy = true,
	event = "LspAttach",
	opts = {
		enable = true,
		include_declaration = true,
		sections = {
			definitions = true,
		},
	},
}
