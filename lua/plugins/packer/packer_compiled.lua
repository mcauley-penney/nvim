-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/m/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/m/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/m/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/m/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/m/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["bufferline.nvim"] = {
    config = { ' require "plugins.cfgs.bufferline" ' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cacophony.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cacophony.nvim",
    url = "/home/m/files/nonwork/cacophony.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-emoji"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-emoji/after/plugin/cmp_emoji.lua" },
    keys = { { "", ":" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-git"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-latex-symbols"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols/after/plugin/cmp_latex.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols",
    url = "https://github.com/kdheepak/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-vsnip"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-vsnip/after/plugin/cmp_vsnip.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { ' require "plugins.cfgs.indent_blankline" ' },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["indentInsert.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/indentInsert.nvim",
    url = "https://github.com/pedro757/indentInsert.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["null-ls.nvim"] = {
    config = { ' require "plugins.cfgs.null" ' },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { ' require "plugins.cfgs.pairs" ' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    config = { ' require "plugins.cfgs.cmp" ' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { ' require "plugins.cfgs.colorizer" ' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\n»\1\0\0\2\1\2\0\4-\0\0\0005\1\1\0=\1\0\0K\0\1\0\1¿\1\t\0\0\vclangd\17--clang-tidy --completion-style=detailed\24--cross-file-rename\28--header-insertion=iwyu\"--header-insertion-decorators\23--limit-results=10\25--pch-storage=memory\rsettings–\2\0\0\t\1\26\0\"-\0\0\0005\1\24\0005\2\4\0005\3\2\0005\4\1\0=\4\3\3=\3\5\0025\3\6\0006\4\a\0009\4\b\0046\6\t\0009\6\n\6'\a\v\0B\4\3\2=\4\n\3=\3\f\0025\3\r\0=\3\14\0025\3\20\0005\4\18\0006\5\a\0009\5\15\0059\5\16\5'\a\17\0+\b\2\0B\5\3\2=\5\19\4=\4\19\3=\3\21\0025\3\22\0=\3\23\2=\2\25\1=\1\0\0K\0\1\0\1¿\bLua\1\0\0\vformat\1\0\1\venable\2\14workspace\1\0\0\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\14telemetry\1\0\1\venable\1\fruntime\6;\tpath\fpackage\nsplit\bvim\1\0\1\fversion\vLuaJIT\16diagnostics\1\0\0\fglobals\1\0\0\1\2\0\0\bvim\rsettingsæ\1\1\1\b\0\f\0\0275\1\3\0006\2\0\0'\4\1\0B\2\2\0029\2\2\2=\2\4\0015\2\6\0003\3\5\0=\3\a\0023\3\b\0=\3\t\0029\3\n\0008\3\3\2\15\0\3\0X\4\5Ä9\3\n\0008\3\3\2B\3\1\2\14\0\3\0X\4\1Ä\18\3\1\0\18\6\0\0009\4\v\0\18\a\3\0B\4\3\0012\0\0ÄK\0\1\0\nsetup\tname\16sumneko_lua\0\vclangd\1\0\0\0\14on_attach\1\0\0\ronAttach\14lsp.utils\frequireO\1\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0003\2\3\0B\0\2\1K\0\1\0\0\20on_server_ready\23nvim-lsp-installer\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { ' require "plugins.cfgs.ts" ' },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    config = { ' require "plugins.cfgs.icons" ' },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["substitute.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15substitute\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/substitute.nvim",
    url = "https://github.com/gbprod/substitute.nvim"
  },
  ["surround.nvim"] = {
    config = { "\27LJ\2\nb\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19mappings_style\rsandwich\vprefix\n<F14>\nsetup\rsurround\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/surround.nvim",
    url = "https://github.com/blackCauldron7/surround.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["tidy.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/tidy.nvim",
    url = "https://github.com/mcauley-penney/tidy.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { ' require "plugins.cfgs.toggleterm" ' },
    keys = { { "", "<C-space>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "TroubleToggle" },
    config = { ' require "plugins.cfgs.trouble" ' },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-doge"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-doge",
    url = "https://github.com/kkoomen/vim-doge"
  },
  ["vim-highlighturl"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/vim-highlighturl",
    url = "https://github.com/itchyny/vim-highlighturl"
  },
  ["vim-illuminate"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-illuminate",
    url = "https://github.com/rrethy/vim-illuminate"
  },
  ["vim-pasta"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/vim-pasta",
    url = "https://github.com/sickill/vim-pasta"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["vim-swap"] = {
    keys = { { "", "g<" }, { "", "g>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-swap",
    url = "https://github.com/machakann/vim-swap"
  },
  ["vim-vsnip"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    after_files = { "/home/m/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ/after/plugin/vsnip_integ.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["vim-wordmotion"] = {
    keys = { { "", "b" }, { "", "c" }, { "", "d" }, { "", "k" }, { "", "w" }, { "", "y" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-wordmotion",
    url = "https://github.com/chaoren/vim-wordmotion"
  },
  ["virt-column.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tchar\b‚îÇ\nsetup\16virt-column\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/virt-column.nvim",
    url = "https://github.com/lukas-reineke/virt-column.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^cmp"] = "nvim-cmp",
  ["^indentInsert"] = "indentInsert.nvim",
  ["^plenary"] = "plenary.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: surround.nvim
time([[Config for surround.nvim]], true)
try_loadstring("\27LJ\2\nb\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\19mappings_style\rsandwich\vprefix\n<F14>\nsetup\rsurround\frequire\0", "config", "surround.nvim")
time([[Config for surround.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
 require "plugins.cfgs.icons" 
time([[Config for nvim-web-devicons]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\n»\1\0\0\2\1\2\0\4-\0\0\0005\1\1\0=\1\0\0K\0\1\0\1¿\1\t\0\0\vclangd\17--clang-tidy --completion-style=detailed\24--cross-file-rename\28--header-insertion=iwyu\"--header-insertion-decorators\23--limit-results=10\25--pch-storage=memory\rsettings–\2\0\0\t\1\26\0\"-\0\0\0005\1\24\0005\2\4\0005\3\2\0005\4\1\0=\4\3\3=\3\5\0025\3\6\0006\4\a\0009\4\b\0046\6\t\0009\6\n\6'\a\v\0B\4\3\2=\4\n\3=\3\f\0025\3\r\0=\3\14\0025\3\20\0005\4\18\0006\5\a\0009\5\15\0059\5\16\5'\a\17\0+\b\2\0B\5\3\2=\5\19\4=\4\19\3=\3\21\0025\3\22\0=\3\23\2=\2\25\1=\1\0\0K\0\1\0\1¿\bLua\1\0\0\vformat\1\0\1\venable\2\14workspace\1\0\0\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\14telemetry\1\0\1\venable\1\fruntime\6;\tpath\fpackage\nsplit\bvim\1\0\1\fversion\vLuaJIT\16diagnostics\1\0\0\fglobals\1\0\0\1\2\0\0\bvim\rsettingsæ\1\1\1\b\0\f\0\0275\1\3\0006\2\0\0'\4\1\0B\2\2\0029\2\2\2=\2\4\0015\2\6\0003\3\5\0=\3\a\0023\3\b\0=\3\t\0029\3\n\0008\3\3\2\15\0\3\0X\4\5Ä9\3\n\0008\3\3\2B\3\1\2\14\0\3\0X\4\1Ä\18\3\1\0\18\6\0\0009\4\v\0\18\a\3\0B\4\3\0012\0\0ÄK\0\1\0\nsetup\tname\16sumneko_lua\0\vclangd\1\0\0\0\14on_attach\1\0\0\ronAttach\14lsp.utils\frequireO\1\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0003\2\3\0B\0\2\1K\0\1\0\0\20on_server_ready\23nvim-lsp-installer\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Config for: substitute.nvim
time([[Config for substitute.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15substitute\frequire\0", "config", "substitute.nvim")
time([[Config for substitute.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
 require "plugins.cfgs.null" 
time([[Config for null-ls.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
 require "plugins.cfgs.indent_blankline" 
time([[Config for indent-blankline.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
 require "plugins.cfgs.ts" 
time([[Config for nvim-treesitter]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TroubleToggle lua require("packer.load")({'trouble.nvim'}, { cmd = "TroubleToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> w <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "w", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-space> <cmd>lua require("packer.load")({'toggleterm.nvim'}, { keys = "<lt>C-space>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> y <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "y", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> b <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "b", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> g> <cmd>lua require("packer.load")({'vim-swap'}, { keys = "g>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> g< <cmd>lua require("packer.load")({'vim-swap'}, { keys = "g<lt>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> c <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "c", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> : <cmd>lua require("packer.load")({'cmp-emoji'}, { keys = ":", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> d <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "d", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> k <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "k", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType sh ++once lua require("packer.load")({'cmp-nvim-lsp', 'vim-doge', 'lsp_signature.nvim'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType gitcommit ++once lua require("packer.load")({'cmp-git'}, { ft = "gitcommit" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType c ++once lua require("packer.load")({'cmp-nvim-lsp', 'vim-doge', 'lsp_signature.nvim'}, { ft = "c" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'cmp-nvim-lua', 'nvim-colorizer.lua', 'cmp-nvim-lsp', 'vim-doge', 'lsp_signature.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'cmp-nvim-lsp', 'vim-doge', 'lsp_signature.nvim'}, { ft = "python" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'cmp-emoji', 'cmp-git', 'cmp-latex-symbols', 'vim-vsnip', 'vim-vsnip-integ', 'cmp-nvim-lua', 'cmp-path', 'virt-column.nvim', 'cmp-vsnip', 'nvim-autopairs', 'nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'lsp_signature.nvim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'vim-illuminate'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au BufHidden * ++once lua require("packer.load")({'bufferline.nvim'}, { event = "BufHidden *" }, _G.packer_plugins)]]
vim.cmd [[au BufWritePre * ++once lua require("packer.load")({'tidy.nvim'}, { event = "BufWritePre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
