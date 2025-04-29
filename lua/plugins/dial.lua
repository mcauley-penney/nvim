return {
  "monaqa/dial.nvim",
  keys = { "<C-a>", "g<C-a>", "<C-x>", "g<C-x>" },
  config = function()
    local augend = require("dial.augend")
    local map = vim.keymap.set
    local manip = require("dial.map").manipulate

    map("n", "<C-a>", function() manip("increment", "normal") end)
    map("n", "<C-x>", function() manip("decrement", "normal") end)
    map("n", "g<C-a>", function() manip("increment", "gnormal") end)
    map("n", "g<C-x>", function() manip("decrement", "gnormal") end)
    map("v", "<C-a>", function() manip("increment", "visual") end)
    map("v", "<C-x>", function() manip("decrement", "visual") end)
    map("v", "g<C-a>", function() manip("increment", "gvisual") end)
    map("v", "g<C-x>", function() manip("decrement", "gvisual") end)

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

        require("dial.augend").constant.new({ elements = { "and", "or" }, word = true, }),
        require("dial.augend").constant.new({ elements = { "True", "False" }, word = true, }),
      },
    })
  end
}
