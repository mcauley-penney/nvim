local M = {}

M.pad_str = function(in_str, width, align)
	-- right aligns content
	-- https://vimhelp.org/options.txt.html#%27statusline%27
	local ralign_token = "%="

	local num_spaces = width - #in_str
	if num_spaces < 1 then num_spaces = 1 end
	local spaces = string.rep(" ", num_spaces)

	if align == "left" then
		return table.concat({ in_str, spaces })
	end

	return table.concat({ spaces, in_str, ralign_token })
end

return M
