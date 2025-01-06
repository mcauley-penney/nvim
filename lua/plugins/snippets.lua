return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  build = "make install_jsregexp",
  config = function()
    require("luasnip").config.setup({
      enable_autosnippets = true,
      history = true,
      region_check_events = "CursorMoved,CursorHold,InsertEnter",
      delete_check_events = "InsertLeave",
      ext_opts = {
        [require('luasnip.util.types').choiceNode] = {
          active = {
            hl_mode = 'combine',
            virt_text = { { '●', 'Operator' } },
          },
        },
        [require('luasnip.util.types').insertNode] = {
          active = {
            hl_mode = 'combine',
            virt_text = { { '●', 'Operator' } },
          },
        },
      },
    })

    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local rep = require("luasnip.extras").rep

    -- <c-l> is selecting within a list of options.
    vim.keymap.set('i', '<C-l>', function()
      if ls.choice_active() then ls.change_choice(1) end
    end)

    -- forward
    vim.keymap.set('i', '<C-n>', function()
      if ls.expand_or_jumpable() then ls.expand_or_jump() end
    end)

    -- back
    vim.keymap.set('i', '<C-p>', function()
      if ls.jumpable(-1) then ls.jump(-1) end
    end
    )

    ls.add_snippets("markdown", {
      s("cap", {
        t('<sub>'),
        i(1),
        t('</sub>'),
      }),
      s("link", {
        t('['),
        i(1),
        t(']('),
        i(2),
        t(')'),
      }),
      s("props", {
        t("---"),
        t({ "", "source:" }),
        t({ "", "  - " }),
        t({ "", "tags:" }),
        t({ "", "  - " }), i(1),
        t({ "", "---" }),
      }),
      s("tbl", {
        --[[
               |-----------------+--------------------------+------------|
               | name            | address                  | phone      |
               |-----------------+--------------------------+------------|
               | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
               |-----------------+--------------------------+------------|
               | Sherlock Holmes | 221B Baker Street        | 0987654321 |
               |-----------------+--------------------------+------------|
           ]]
        t("|-----------------|--------------------------|------------|"),
        t({ "", "| name            | address                  | phone      |" }),
        t({ "", "|-----------------|--------------------------|------------|" }),
        t({ "", "| John Adams      | 1600 Pennsylvania Avenue | 0123456789 |" }),
        t({ "", "|-----------------|--------------------------|------------|" }),
        t({ "", "| Sherlock Holmes | 221B Baker Street        | 0987654321 |" }),
        t({ "", "|-----------------|--------------------------|------------|" }),
      })
    })

    ls.add_snippets("tex", {
      s("env", {
        t("\\begin{"), i(1), t("}"),
        t({ "", "\t" }), i(0),
        t({ "", "\\end{" }), rep(1), t("}")
      })
    })

    ls.add_snippets("lua", {
      s("inspect", {
        t("vim.inspect("), i(1), t(")"),
      })
    })
  end
}
