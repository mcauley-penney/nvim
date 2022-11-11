for _, mod in ipairs({ "diagnostics", "vim_ui" }) do
	require("jmp.ui." .. mod)
end
