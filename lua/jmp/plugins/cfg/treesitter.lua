require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
  },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the
    -- same time. Set this to `true` if you depend on 'syntax' being
    -- enabled (like for indentation). Using this option may slow down your
    -- editor, and you may see some duplicate highlights. Instead of true
    -- it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ["ic"] = "@conditional.inner",
        ["ac"] = "@conditional.outer",

        ["if"] = "@function.inner",
        ["af"] = "@function.outer",

        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
      },
    },
  },
})
