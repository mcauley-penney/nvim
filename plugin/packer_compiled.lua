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
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bufferline.nvim"] = {
    config = { "require 'jmp.plugins.cfg.bufferline'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-git"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fcmp_git\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-latex-symbols",
    url = "https://github.com/kdheepak/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["dial.nvim"] = {
    config = { "require 'jmp.plugins.cfg.dial'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\nº\1\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\vwindow\1\0\2\nblend\3\0\rrelative\veditor\ntimer\1\0\1\17spinner_rate\3–\1\ttext\1\0\0\fspinner\1\0\0\1\5\0\0\bïŸ¦\bïŸ¥\bï†®\bïŸ¥\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "require 'jmp.plugins.cfg.gitsigns'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\21arstneioqwfpluy;\nsetup\bhop\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "require 'jmp.plugins.cfg.indent_blankline'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  neogen = {
    config = { "require 'jmp.plugins.cfg.neogen'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/neogen",
    url = "https://github.com/danymat/neogen"
  },
  ["null-ls.nvim"] = {
    config = { "require 'jmp.plugins.cfg.null_ls'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "require 'jmp.plugins.cfg.pairs'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\n{\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fpreview\1\0\0\17border_chars\1\0\1\15win_height\3ç\a\1\n\0\0\5\5\5\5\5\5\5\5\5\nsetup\bbqf\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    config = { "require 'jmp.plugins.cfg.cmp'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\5\0\0\bcss\blua\ttext\bvim\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-docs-view"] = {
    config = { "\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\rposition\vbottom\nsetup\14docs-view\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-docs-view",
    url = "https://github.com/amrbashir/nvim-docs-view"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\n¥\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\aui\1\0\0\nicons\1\0\0\1\0\3\23server_uninstalled\bâœ—\19server_pending\bâ–º\21server_installed\bâœ“\nsetup\23nvim-lsp-installer\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    config = { "require 'jmp.plugins.cfg.lspconfig'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-pqf"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bpqf\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-pqf",
    url = "https://gitlab.com/yorickpeterse/nvim-pqf"
  },
  ["nvim-scrollbar"] = {
    config = { "require 'jmp.plugins.cfg.scrollbar'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-treesitter"] = {
    config = { "require 'jmp.plugins.cfg.treesitter'" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
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
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["still_light.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/still_light.nvim",
    url = "/home/m/files/nonwork/still_light.nvim"
  },
  ["substitute.nvim"] = {
    config = { "\27LJ\2\n›\2\0\0\a\0\15\00026\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0006\4\5\0'\6\6\0B\4\2\0029\4\a\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\b\0006\4\5\0'\6\6\0B\4\2\0029\4\t\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0006\4\5\0'\6\6\0B\4\2\0029\4\v\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\f\0'\3\4\0006\4\5\0'\6\6\0B\4\2\0029\4\r\0044\5\0\0B\0\5\0016\0\5\0'\2\6\0B\0\2\0029\0\14\0B\0\1\1K\0\1\0\nsetup\vvisual\6x\beol\6R\tline\arr\roperator\15substitute\frequire\6r\6n\bset\vkeymap\bvim\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/substitute.nvim",
    url = "https://github.com/gbprod/substitute.nvim"
  },
  ["symbols-outline.nvim"] = {
    config = { "\27LJ\2\no\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\4\27highlight_hovered_item\2\17auto_preview\2\nwidth\3<\16show_guides\1\20symbols_outline\6g\bvim\0" },
    loaded = true,
    needs_bufread = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tidy.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ttidy\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/tidy.nvim",
    url = "https://github.com/mcauley-penney/tidy.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\nf\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\14direction\nfloat\17open_mapping\14<C-space>\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["venn.nvim"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/venn.nvim",
    url = "https://github.com/jbyuki/venn.nvim"
  },
  ["vim-highlighturl"] = {
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/vim-highlighturl",
    url = "https://github.com/itchyny/vim-highlighturl"
  },
  ["vim-illuminate"] = {
    config = { "\27LJ\2\nb\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1,\1=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0K\0\1\0$Illuminate_highlightUnderCursor\21Illuminate_delay\6g\bvim\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/vim-illuminate",
    url = "https://github.com/rrethy/vim-illuminate"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle" },
    config = { "\27LJ\2\nÊ\1\0\0\2\0\a\0\0176\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0K\0\1\0\1\0\5\n<esc>\tquit\6n\15mode_older\6q\tquit\6e\15mode_newer\t<cr>\fpreview\19mundo_mappings\16mundo_right\25mundo_preview_bottom\17mundo_header\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/m/.local/share/nvim/site/pack/packer/opt/vim-mundo",
    url = "https://github.com/simnalamburt/vim-mundo"
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
    config = { "\27LJ\2\nq\0\0\6\0\b\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\6\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\ag>\f<right>\ag<\v<left>\6n\bset\vkeymap\bvim\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/vim-swap",
    url = "https://github.com/machakann/vim-swap"
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
    config = { "\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tchar\bâ”‚\nsetup\16virt-column\frequire\0" },
    loaded = true,
    path = "/home/m/.local/share/nvim/site/pack/packer/start/virt-column.nvim",
    url = "https://github.com/lukas-reineke/virt-column.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-mundo
time([[Setup for vim-mundo]], true)
try_loadstring("\27LJ\2\ng\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2\25<cmd>MundoToggle<cr>\14<leader>u\6n\bset\vkeymap\bvim\0", "setup", "vim-mundo")
time([[Setup for vim-mundo]], false)
-- Setup for: markdown-preview.nvim
time([[Setup for markdown-preview.nvim]], true)
try_loadstring("\27LJ\2\nò\1\0\0\2\0\n\0\0216\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0'\1\5\0=\1\4\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0006\0\0\0009\0\1\0005\1\t\0=\1\b\0K\0\1\0\1\0\2\21disable_filename\3\1\24disable_sync_scroll\3\0\25mkdp_preview_options\15${name}.md\20mkdp_page_title\ffirefox\17mkdp_browser\20mkdp_auto_close\20mkdp_auto_start\6g\bvim\0", "setup", "markdown-preview.nvim")
time([[Setup for markdown-preview.nvim]], false)
-- Setup for: symbols-outline.nvim
time([[Setup for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\ne\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\28<cmd>SymbolsOutline<cr>\n<F13>\6n\bset\vkeymap\bvim\0", "setup", "symbols-outline.nvim")
time([[Setup for symbols-outline.nvim]], false)
time([[packadd for symbols-outline.nvim]], true)
vim.cmd [[packadd symbols-outline.nvim]]
time([[packadd for symbols-outline.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\nf\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\14direction\nfloat\17open_mapping\14<C-space>\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require 'jmp.plugins.cfg.treesitter'
time([[Config for nvim-treesitter]], false)
-- Config for: dial.nvim
time([[Config for dial.nvim]], true)
require 'jmp.plugins.cfg.dial'
time([[Config for dial.nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
require 'jmp.plugins.cfg.bufferline'
time([[Config for bufferline.nvim]], false)
-- Config for: virt-column.nvim
time([[Config for virt-column.nvim]], true)
try_loadstring("\27LJ\2\nI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tchar\bâ”‚\nsetup\16virt-column\frequire\0", "config", "virt-column.nvim")
time([[Config for virt-column.nvim]], false)
-- Config for: nvim-scrollbar
time([[Config for nvim-scrollbar]], true)
require 'jmp.plugins.cfg.scrollbar'
time([[Config for nvim-scrollbar]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
require 'jmp.plugins.cfg.pairs'
time([[Config for nvim-autopairs]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
require 'jmp.plugins.cfg.gitsigns'
time([[Config for gitsigns.nvim]], false)
-- Config for: cmp-git
time([[Config for cmp-git]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fcmp_git\frequire\0", "config", "cmp-git")
time([[Config for cmp-git]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\nº\1\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\vwindow\1\0\2\nblend\3\0\rrelative\veditor\ntimer\1\0\1\17spinner_rate\3–\1\ttext\1\0\0\fspinner\1\0\0\1\5\0\0\bïŸ¦\bïŸ¥\bï†®\bïŸ¥\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
try_loadstring("\27LJ\2\no\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\4\27highlight_hovered_item\2\17auto_preview\2\nwidth\3<\16show_guides\1\20symbols_outline\6g\bvim\0", "config", "symbols-outline.nvim")
time([[Config for symbols-outline.nvim]], false)
-- Config for: vim-illuminate
time([[Config for vim-illuminate]], true)
try_loadstring("\27LJ\2\nb\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1,\1=\1\2\0006\0\0\0009\0\1\0)\1\0\0=\1\3\0K\0\1\0$Illuminate_highlightUnderCursor\21Illuminate_delay\6g\bvim\0", "config", "vim-illuminate")
time([[Config for vim-illuminate]], false)
-- Config for: nvim-pqf
time([[Config for nvim-pqf]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bpqf\frequire\0", "config", "nvim-pqf")
time([[Config for nvim-pqf]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\nP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\5\0\0\bcss\blua\ttext\bvim\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
try_loadstring("\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\tkeys\21arstneioqwfpluy;\nsetup\bhop\frequire\0", "config", "hop.nvim")
time([[Config for hop.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
require 'jmp.plugins.cfg.null_ls'
time([[Config for null-ls.nvim]], false)
-- Config for: substitute.nvim
time([[Config for substitute.nvim]], true)
try_loadstring("\27LJ\2\n›\2\0\0\a\0\15\00026\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0006\4\5\0'\6\6\0B\4\2\0029\4\a\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\b\0006\4\5\0'\6\6\0B\4\2\0029\4\t\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0006\4\5\0'\6\6\0B\4\2\0029\4\v\0044\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\f\0'\3\4\0006\4\5\0'\6\6\0B\4\2\0029\4\r\0044\5\0\0B\0\5\0016\0\5\0'\2\6\0B\0\2\0029\0\14\0B\0\1\1K\0\1\0\nsetup\vvisual\6x\beol\6R\tline\arr\roperator\15substitute\frequire\6r\6n\bset\vkeymap\bvim\0", "config", "substitute.nvim")
time([[Config for substitute.nvim]], false)
-- Config for: neogen
time([[Config for neogen]], true)
require 'jmp.plugins.cfg.neogen'
time([[Config for neogen]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
require 'jmp.plugins.cfg.indent_blankline'
time([[Config for indent-blankline.nvim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\n¥\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\aui\1\0\0\nicons\1\0\0\1\0\3\23server_uninstalled\bâœ—\19server_pending\bâ–º\21server_installed\bâœ“\nsetup\23nvim-lsp-installer\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require 'jmp.plugins.cfg.lspconfig'
time([[Config for nvim-lspconfig]], false)
-- Config for: tidy.nvim
time([[Config for tidy.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ttidy\frequire\0", "config", "tidy.nvim")
time([[Config for tidy.nvim]], false)
-- Config for: vim-swap
time([[Config for vim-swap]], true)
try_loadstring("\27LJ\2\nq\0\0\6\0\b\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\6\0'\4\a\0004\5\0\0B\0\5\1K\0\1\0\ag>\f<right>\ag<\v<left>\6n\bset\vkeymap\bvim\0", "config", "vim-swap")
time([[Config for vim-swap]], false)
-- Config for: nvim-bqf
time([[Config for nvim-bqf]], true)
try_loadstring("\27LJ\2\n{\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fpreview\1\0\0\17border_chars\1\0\1\15win_height\3ç\a\1\n\0\0\5\5\5\5\5\5\5\5\5\nsetup\bbqf\frequire\0", "config", "nvim-bqf")
time([[Config for nvim-bqf]], false)
-- Config for: nvim-docs-view
time([[Config for nvim-docs-view]], true)
try_loadstring("\27LJ\2\nN\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\rposition\vbottom\nsetup\14docs-view\frequire\0", "config", "nvim-docs-view")
time([[Config for nvim-docs-view]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require 'jmp.plugins.cfg.cmp'
time([[Config for nvim-cmp]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MundoToggle lua require("packer.load")({'vim-mundo'}, { cmd = "MundoToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> w <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "w", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> y <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "y", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> k <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "k", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> c <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "c", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> d <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "d", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> b <cmd>lua require("packer.load")({'vim-wordmotion'}, { keys = "b", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
