local M = {}

M.pad_str = function(in_str, width, indent, align)
	local indent_str = indent and "%= " or ""

	local num_spaces = width - #in_str
	if num_spaces <= 0 then num_spaces = 1 end

	if align == "left" then
		return table.concat({ in_str, string.rep(" ", num_spaces), indent_str })
	else
		return table.concat({ string.rep(" ", num_spaces), in_str, indent_str })
	end
end

return M
