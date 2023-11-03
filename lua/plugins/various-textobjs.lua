return {
	{
		"chrisgrieser/nvim-various-textobjs",
		init = function()
			local map = vim.keymap.set
			local modes = { "o", "x" }
			-- indentation
			map(modes, "ii", function() require("various-textobjs").indentation(true, true) end)
			map(modes, "ai", function() require("various-textobjs").indentation(false, true) end)

			-- values, e.g. variable assignment
			map(modes, "iv", function() require("various-textobjs").value(true) end)
			map(modes, "av", function() require("various-textobjs").value(false) end)
		end
	}
}
