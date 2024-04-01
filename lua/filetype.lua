-- https://github.com/gennaro-tedesco/dotfiles/blob/28be096a90a7c1fbadde62bdac3fd2a78492fcde/nvim/lua/filetype.lua#L7
vim.filetype.add({
  filename = {
    [".env"] = "config",
  },
  pattern = {
    ["gitconf.*"] = "gitconfig",
  },
})
