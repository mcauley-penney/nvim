local function format(count, label)
  return string.format("%s %s%s", count, label, count > 1 and 's' or '')
end

return {
  "mcauley-penney/lsp-lens.nvim",
  opts = {
    separator = " | ",
    sections = {
      definition = function(count)
        return format(count, "definition")
      end,
      references = function(count)
        return format(count, "reference")
      end,
      implements = function(count)
        return format(count, "implementation")
      end,
      git_authors = false,
    },
  },
  config = function(_, opts)
    require("lsp-lens").setup(opts)

    vim.api.nvim_set_hl(0, "LspLens", { link = "LineNr" })
  end
}
