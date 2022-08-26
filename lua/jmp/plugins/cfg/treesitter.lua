require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "json",
    "latex",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "org",
    "python",
  },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- Setting this to true will run `:h syntax` and tree-sitter at the
    -- same time. Set this to `true` if you depend on 'syntax' being
    -- enabled (like for indentation). Using this option may slow down your
    -- editor, and you may see some duplicate highlights. Instead of true
    -- it can also be a list of languages
    enable = true,

    -- ORG: Required for spellcheck, some LaTex highlights and code
    -- block highlights that do not have ts grammar
    additional_vim_regex_highlighting = { 'org' },
  },

  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ["iC"] = "@call.inner",
        ["aC"] = "@call.outer",

        ["ic"] = "@conditional.inner",
        ["ac"] = "@conditional.outer",

        ["if"] = "@function.inner",
        ["af"] = "@function.outer",

        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",


      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    }
  },
})
