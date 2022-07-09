local M = {}

M.bootstrap_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    print("Cloning packer ..")
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd("packadd! packer.nvim")

    require("packer").startup({
      function(use)
        for _, plugin in ipairs(require("jmp.plugins")) do
          use(plugin)
        end
      end,
    })
    require("packer").sync()
    return
  end
end

return M
