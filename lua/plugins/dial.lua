return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    local toggle = require("dial.augend").constant.new
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
      default = {
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.alias.bool,
        augend.integer.alias.decimal_int,
        augend.date.new {
          pattern = "%Y-%m-%d",
          default_kind = "day",
          only_valid = true,
        },
        augend.date.new {
          pattern = "%m-%d",
          default_kind = "day",
          only_valid = true,
        },

        toggle({ elements = { "and", "or" }, word = true, }),
        toggle({ elements = { "True", "False" }, word = true, }),
      },
    })
  end
}
