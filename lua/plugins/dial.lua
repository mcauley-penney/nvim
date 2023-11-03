return {
	-- FIXME: negative is broken
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			local dial = require("dial.map")
			local expr = { expr = true, remap = false }
			local map = vim.keymap.set

			map("n", "<C-a>", dial.inc_normal, expr)
			map("n", "<C-x>", dial.dec_normal, expr)
			map("v", "<C-a>", dial.inc_visual, expr)
			map("v", "<C-x>", dial.dec_visual, expr)
			map("v", "g<C-a>", dial.inc_gvisual, expr)
			map("v", "g<C-x>", dial.dec_gvisual, expr)

			require("dial.config").augends:register_group({
				-- default augends used when no group name is specified
				default = {
					augend.constant.alias.alpha,
					augend.constant.alias.Alpha,
					augend.constant.alias.bool,
					augend.integer.alias.decimal_int,
					augend.date.alias["%Y-%m-%d"], -- iso 8601
					augend.date.alias["%Y/%m/%d"], -- iso 8601
					augend.date.alias["%m/%d/%y"],
					augend.date.alias["%m/%d"],

					augend.constant.new({
						elements = { "and", "or" },
						word = true,
						cyclic = true,
					}),

					augend.constant.new({
						elements = { "True", "False" },
						word = true,
						cyclic = true,
					}),
				},
			})
		end
	}
}
