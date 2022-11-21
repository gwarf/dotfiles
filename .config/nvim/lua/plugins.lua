-- https://github.com/wbthomason/packer.nvim
-- https://www.chiarulli.me/Neovim-2/03-plugins/

-- Bootstrap packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
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
      return require("packer.util").float({ border = "single" })
    end,
  },
})

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use("lewis6991/impatient.nvim")

  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.nvim-cmp")
    end,
    requires = { "L3MON4D3/LuaSnip", "onsails/lspkind.nvim" },
  })
  -- Add vscode-like pictograms to neovim lsp
  use({ "onsails/lspkind.nvim" })

  -- nvim-cmp completion sources
  -- Snippet engine and snippet template
  -- use { "SirVer/ultisnips", event = "InsertEnter" }
  -- use { "honza/vim-snippets" }
  -- use { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "cmp_luasnip" } }
  -- Snippets
  use("L3MON4D3/LuaSnip")
  use({ "rafamadriz/friendly-snippets" })
  -- Autocompletion
  use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
  use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
  use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
  -- Completion for some neovim lua API
  use({ "ii14/emmylua-nvim", ft = "lua" })
  -- use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
  -- use { "petertriho/cmp-git",
  --   requires = "nvim-lua/plenary.nvim",
  --   config = function() require('cmp_git').setup() end
  -- }
  if vim.g.is_mac then
    use({ "hrsh7th/cmp-emoji", after = "nvim-cmp" })
  end
  -- nvim-lsp configuration
  use({
    "neovim/nvim-lspconfig",
    after = { "cmp-nvim-lsp", "mason-lspconfig.nvim" },
    config = function()
      require("config.lsp")
    end,
  })
  -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
  use({ "williamboman/mason.nvim" })
  use({
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    config = function()
      require("config.mason-lspconfig")
    end,
    requires = { "williamboman/mason.nvim", "nvim-lspconfig" },
  })
  use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("config.mason-tool-installer")
    end,
  })

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  -- Use different binaries as sources, like prettier
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("config.null-ls")
    end,
  })

  -- Clean spaces at EOL for lines that are edited
  use("thirtythreeforty/lessspace.vim")

  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  -- Easy change of surrounding stuff (tags, quotes...)
  -- sa: sandwich add + text object + text
  -- saw`: surround word with `
  -- sd: sandwich delete
  -- sdt: delete surrounding tag
  -- sr: sandwich replace
  -- sr_`: replace _ by `
  use("machakann/vim-sandwich")
  use({ "michaeljsmith/vim-indent-object", event = "VimEnter" })

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- if utils.executable("tmux") then
  -- .tmux.conf syntax highlighting and setting check
  use({ "tmux-plugins/vim-tmux", ft = { "tmux" } })
  -- end

  -- Use :Telescope
  -- https://alpha2phi.medium.com/neovim-for-beginners-fuzzy-file-search-part-2-2aab95fe8cfe
  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope.actions")
      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  })
  -- pretty list for showing diagnostics, references, telescope results, quickfix and location lists
  -- https://github.com/folke/trouble.nvim
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
      })
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
      vim.keymap.set(
        "n",
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
    end,
  })

  -- Lazy loading:
  -- Load on specific commands
  -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- highlight, navigate, and operate on sets of matching text
  -- https://github.com/andymass/vim-matchup
  use({
    "andymass/vim-matchup",
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    event = "VimEnter",
  })

  -- Linting and formatting
  -- XXX replaced by null-ls
  -- use {
  --   'w0rp/ale',
  --   --   ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --   cmd = 'ALEEnable',
  -- }

  -- Post-install/update hook with neovim command
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  -- open last postiion in file
  use("farmergreg/vim-lastplace")

  use("simnalamburt/vim-mundo")

  -- Post-install/update hook with call of vimscript function with argument
  -- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use specific branch, dependency and run lua file after load
  -- use {
  --   'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
  --   requires = {'kyazdani42/nvim-web-devicons'}
  -- }

  -- Use dracula theme
  -- use({
  --   "dracula/vim", as = "dracula",
  --   config = function()
  --     vim.cmd([[colorscheme dracula]])
  --   end,
  -- })
  use({
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- set italic comment
        italic_comment = true, -- default false
      })
      vim.cmd([[colorscheme dracula]])
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    after = "dracula.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "dracula" },
      })
    end,
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        yadm = {
          enable = true,
        },
      })
    end,
    requires = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
  })

  -- Notifications
  use("rcarriga/nvim-notify")
  -- use 'vigoux/notifier.nvim'
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
