-- https://github.com/wbthomason/packer.nvim
-- https://www.chiarulli.me/Neovim-2/03-plugins/

-- Bootstrap packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd("packadd packer.nvim")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
})

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

  -- Completion
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.nvim-cmp")
    end,
    requires = { "L3MON4D3/LuaSnip", "onsails/lspkind.nvim" }
  }
  -- Add vscode-like pictograms to neovim lsp
  use { "onsails/lspkind.nvim" }

  -- nvim-cmp completion sources
  -- Snippet engine and snippet template
  -- use { "SirVer/ultisnips", event = "InsertEnter" }
  -- use { "honza/vim-snippets" }
  -- use { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "cmp_luasnip" } }
  -- Snippets
  use "L3MON4D3/LuaSnip"
  use {'rafamadriz/friendly-snippets'}
  -- Autocompletion
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  use { "hrsh7th/cmp-cmdline", after = "nvim-cmp" }
  use {'saadparwaiz1/cmp_luasnip', after = "nvim-cmp" }
  -- Completion for some neovim lua API
  use { "ii14/emmylua-nvim", ft = "lua" }
  -- use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
  -- use { "petertriho/cmp-git",
  --   requires = "nvim-lua/plenary.nvim",
  --   config = function() require('cmp_git').setup() end
  -- }
  if vim.g.is_mac then
    use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
  end
  -- nvim-lsp configuration
  use { "neovim/nvim-lspconfig",
    after = { "cmp-nvim-lsp", "mason-lspconfig.nvim" },
    config = function()
      require('config.lsp')
    end
  }
  -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    config = function ()
      require("config.mason-lspconfig")
    end,
    requires = {"williamboman/mason.nvim", "nvim-lspconfig"}
  }
  use { "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function ()
      require('mason-tool-installer').setup {
        ensure_installed = {
          "pylint",
        },
        auto_update = true,
        run_on_start = true,
        tart_delay = 3000, -- 3 second delay
      }
    end,
  }

 --  use {
 --    "jose-elias-alvarez/null-ls.nvim",
 --    config = function ()
 --      require("config.null-ls")
 --    end
 --  }
 --  use { "jayp0521/mason-null-ls.nvim",
 --     after = "null-ls.nvim",
 --    config = function ()
 --       require("config.mason-null-ls")
--        require("mason").setup()
--        require("null-ls").setup()
 --       require("mason-null-ls").setup({
 --         automatic_setup = true,
 --       })
 --    end
 --  }

  -- Clean spaces at EOL for lines that are edited
  use "thirtythreeforty/lessspace.vim"

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }

  -- Easy change of surrounding stuff (tags, quotes...)
  -- sa: sandwich add + text object + text
  -- saw`: surround word with `
  -- sd: sandwich delete
  -- sdt: delete surrounding tag
  -- sr: sandwich replace
  -- sr_`: replace _ by `
  use "machakann/vim-sandwich"
  use { "michaeljsmith/vim-indent-object", event = "VimEnter" }

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- if utils.executable("tmux") then
  -- .tmux.conf syntax highlighting and setting check
  use { "tmux-plugins/vim-tmux", ft = { "tmux" } }
  -- end

  -- Use :Telescope
  use 'nvim-telescope/telescope.nvim'

  -- Lazy loading:
  -- Load on specific commands
  -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- highlight, navigate, and operate on sets of matching text
  -- https://github.com/andymass/vim-matchup
  use {
    'andymass/vim-matchup',
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    event = 'VimEnter'
  }

  -- Lintent and formatting
  -- XXX replaced by null-ls
  -- use {
  --   'w0rp/ale',
  --   --   ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --   cmd = 'ALEEnable',
  -- }

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- open last postiion in file
  use "farmergreg/vim-lastplace"

  use "simnalamburt/vim-mundo"

  -- Post-install/update hook with call of vimscript function with argument
  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use specific branch, dependency and run lua file after load
  -- use {
  --   'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
  --   requires = {'kyazdani42/nvim-web-devicons'}
  -- }

  -- Use dracula theme
  -- use { 'dracula/vim', as = 'dracula',
  use {
    'Mofiqul/dracula.nvim',
    config = function()
      require("dracula").setup{
          -- show the '~' characters after the end of buffers
          show_end_of_buffer = true, -- default false
          -- set italic comment
          italic_comment = true, -- default false
      }
      vim.cmd [[colorscheme dracula]]
    end
  }

  use "kyazdani42/nvim-web-devicons"

  use {
    'nvim-lualine/lualine.nvim',
    after = "dracula.nvim",
    config = function()
      require('lualine').setup {
        options = { theme = 'dracula' }
      }
    end,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'lewis6991/gitsigns.nvim',
     config = function()
       require("gitsigns").setup()
     end,
    requires = { 'nvim-lua/plenary.nvim' },
    event = "BufRead",
  }

  -- Notifications
  use 'rcarriga/nvim-notify'
  -- use 'vigoux/notifier.nvim'
  use { "j-hui/fidget.nvim",
    config = function ()
      require"fidget".setup{}
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
