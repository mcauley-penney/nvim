return {
  "windwp/nvim-autopairs",
  opts = {
    break_undo = true,
    check_ts = true,
    disable_in_macro = true,
    disable_in_replace_mode = false,
    disable_in_visualblock = false,
    enable_abbr = false,
    enable_afterquote = false,
    enable_bracket_in_quote = false,
    enable_check_bracket_line = true,
    enable_moveright = false,
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    map_bs = true,
    map_c_h = true,
    map_c_w = false,
    map_cr = true,
    fast_wrap = {
      map = '<C-w>',
    }
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    -- stolen from https://github.com/chrisgrieser/.config/blob/ee1d4eb9b83601c5ad60c81d5c68c0a28878d3ea/nvim/lua/plugins/editing-support.lua#L41C2-L41C2
    local rule = require("nvim-autopairs.rule")
    local is_node_type = require("nvim-autopairs.ts-conds").is_ts_node
    local is_not_node_type = require("nvim-autopairs.ts-conds").is_not_ts_node
    local neg_lookahead = require("nvim-autopairs.conds").not_after_regex

    require("nvim-autopairs").add_rules {
      rule("<", ">", "lua"):with_pair(is_node_type { "string", "string_content" }),
      rule("<", ">", { "html", "vim", "xml" }),               -- keymaps & tags
      rule("![", "]()", "markdown"):set_end_pair_length(1),   -- images

      -- git conventional commit with scope: auto-append `:`
      rule("^%a+%(%)", ":", "gitcommit")
          :use_regex(true)
          :with_pair(neg_lookahead(".+"))
          :with_pair(is_not_node_type("message"))
          :with_move(function(options) return options.char == ":" end),
    }
  end
}
