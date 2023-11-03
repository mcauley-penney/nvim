local M = {}

M.pad_str = function(in_str, width, align)
	local num_spaces = width - #in_str
	if num_spaces < 1 then
		num_spaces = 1
	end

	local spaces = string.rep(" ", num_spaces)

	if align == "left" then
		return table.concat({ in_str, spaces })
	end

	return table.concat({ spaces, in_str })
end

return M
