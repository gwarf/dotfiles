-- https://github.com/wbthomason/packer.nvim
-- https://www.chiarulli.me/Neovim-2/03-plugins/

local utils = require("utils")

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
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
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
  -- https://github.com/topics/nvim-cmp
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.nvim-cmp")
    end,
    requires = {
      -- Snippet engine
      "L3MON4D3/LuaSnip",
      -- Add vscode-like pictograms to neovim lsp
      "onsails/lspkind.nvim",
      -- Snippets
      "rafamadriz/friendly-snippets",
    },
  })
  use({ "L3MON4D3/LuaSnip", tag = "v1.*" })

  -- nvim-cmp completion sources
  -- https://github.com/uga-rosa/cmp-dictionary
  -- https://github.com/lukas-reineke/cmp-rg
  use({
    -- Complete from LSP client
    "hrsh7th/cmp-nvim-lsp",
    -- Complete neovim's Lua runtime API such vim.lsp
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",
    -- Complete from lusasnp
    "saadparwaiz1/cmp_luasnip",
    -- Expecting to be able to get vimmail completion via omnifunc
    -- XXX addresses are shown, but slowwing and parasiting too much mail editing
    -- "hrsh7th/cmp-omni",
  })
  -- Neovim completion library for sumneko/lua-language-server
  use({ "ii14/emmylua-nvim", ft = "lua" })
  -- use {
  --   "petertriho/cmp-git",
  --   requires = "nvim-lua/plenary.nvim",
  --   config = function() require('cmp_git').setup() end
  -- }
  -- nvim-lsp configuration
  use({
    "neovim/nvim-lspconfig",
    config = function()
      -- Install packages
      require("config.mason")
      -- Manage LSP servers, DAP servers, linters, and formatters.
      require("config.lsp")
    end,
    after = { "cmp-nvim-lsp" },
    requires = {
      "williamboman/mason.nvim",
      "nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
      -- Use different binaries as sources, like prettier
      -- XXX null-ls is breaking gq mapping
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
      "jose-elias-alvarez/null-ls.nvim",
      -- Using ltex-ls for spellchecking
      "vigoux/ltex-ls.nvim",
      -- Show LSP server status
      "j-hui/fidget.nvim",
    },
  })

  -- mail helper, mainly for searching for contacts
  use({
    "https://gitlab.com/dbeniamine/vim-mail",
    config = function()
      require("config.mail")
    end,
    ft = "mail",
  })

  -- Clean spaces at EOL for lines that are edited
  -- XXX try to find a lua-powered alternative
  use({
    "thirtythreeforty/lessspace.vim",
    config = function()
      vim.g.lessspace_blacklist = { "diff", "mail" }
    end,
  })

  -- Autopairs characters
  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })

  -- Easy change of surrounding stuff (tags, quotes...)
  -- :h nvim-surround.usage
  -- Alternative to vim-sandwich to get which-key working
  -- ys: You Surround + text object + text
  -- ysiw(: surround with () with spaces
  -- ysiw): surround with () with no spaces
  -- ds: Delete Surround
  -- ds)
  -- cs: Change Surround
  -- cs'": change quotes around a text
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  })

  use({ "michaeljsmith/vim-indent-object", event = "VimEnter" })

  if utils.executable("tmux") then
    -- .tmux.conf syntax highlighting and setting check
    use({ "tmux-plugins/vim-tmux", ft = { "tmux" } })
  end

  -- Use :Telescope
  -- https://alpha2phi.medium.com/neovim-for-beginners-fuzzy-file-search-part-2-2aab95fe8cfe
  -- XXX Consider https://github.com/nvim-telescope/telescope-frecency.nvim
  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope.actions")
      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            -- XXX to be removed if not used
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "dropdown",
          },
          oldfiles = {
            theme = "dropdown",
          },
        },
        extensions = {
          yank_history = {
            layout_strategy = "vertical",
          },
        },
      })
      telescope.load_extension("yank_history")
    end,
  })
  -- pretty list for showing diagnostics, references, telescope results, quickfix and location lists
  -- https://github.com/folke/trouble.nvim
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        -- XXX currently disabled, causing too many errors
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
      })
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
    end,
  })

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

  -- fold management
  use({
    -- XXX to see if really needed
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup({
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      })
      -- Using ufo provider need remap `zR` and `zM`.
      -- once zM got run it's possible to use other commands
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  })

  --  Treesitter configurations and abstraction layer for Neovim.
  use({
    --  Tree-sitter is a parser generator tool and an incremental parsing library.
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("config.treesitter")
    end,
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
    requires = {
      -- Syntax aware text-objects, select, move, swap, and peek support.
      { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufRead" },
      -- Rainbow parentheses for neovim using tree-sitter.
      { "p00f/nvim-ts-rainbow", event = "BufRead" },
      -- View treesitter information directly in Neovim!
      { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
      -- -- Set commentstring option based on the cursor location in the file
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- Use treesitter to autoclose and autorename html tag
      { "windwp/nvim-ts-autotag" },
    },
  })

  -- open last position in file
  use("farmergreg/vim-lastplace")

  -- Manage undo
  use("simnalamburt/vim-mundo")

  -- netrw replacement
  use({
    "kyazdani42/nvim-tree.lua",
    tag = "nightly",
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>T", "<cmd>NvimTreeToggle<cr>", { silent = true, noremap = true })
    end,
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  })

  -- Comment management
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({})
    end,
  })

  -- project management
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- :ProjectRoot is required to switch project
        manual_mode = true,
        silent_chdir = false,
      })
      require("telescope").load_extension("projects")
      vim.keymap.set("n", "<c-p>", "<cmd>:lua require('telescope').extensions.projects.projects{}<cr>", {})
    end,
  })

  -- org-mode like
  -- https://github.com/nvim-neorg/neorg
  use({
    "nvim-neorg/neorg",
    -- tag = "*",
    ft = "norg",
    after = "nvim-treesitter", -- You may want to specify Telescope here as well
    run = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup({
        load = {
          -- Load everything
          ["core.defaults"] = {},
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.norg.concealer"] = {},
          ["core.norg.journal"] = {},
          ["core.norg.qol.toc"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "~/Documents/notes/work",
                home = "~/Documents/notes/home",
                -- gtd = "~/Documents/notes/gtd",
              },
            },
          },
          -- XXX https://github.com/nvim-neorg/neorg/issues/695
          -- ["core.gtd.base"] = {
          --   config = {
          --     workspace = "gtd",
          --   },
          -- },
          ["core.integrations.telescope"] = {},
          -- ["external.kanban"] = {},
        },
      })
    end,
    requires = {
      "nvim-neorg/neorg-telescope",
      -- Relevant to GTD that is no more supported
      -- "max397574/neorg-kanban",
    },
  })

  -- Better yank management
  use({
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({})
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
    end,
  })

  -- Automatically create missing directories on saving a file
  use({
    "jghauser/mkdir.nvim",
  })

  -- Session manager
  use({
    "Shatur/neovim-session-manager",
    config = function()
      require("session_manager").setup({
        -- Do not autoload previous session
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
      })
      local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {}) -- A global group for all your config autocommands

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "SessionLoadPost",
        group = config_group,
        callback = function()
          require("nvim-tree").toggle(false, true)
        end,
      })
    end,
  })

  -- list and switch between buffers
  use({
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    config = function()
      require("bufferline").setup({})
    end,
  })

  -- Git support
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        yadm = {
          enable = false,
        },
      })
    end,
    tag = "v*",
    requires = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
  })

  -- UI, UX, look and fgeel good

  -- displays a popup with possible key bindings
  -- https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/which-key.lua
  use({
    "folke/which-key.nvim",
    config = function()
      require("config.which-key")
    end,
  })

  use({
    -- status line
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.theme")
    end,
    requires = {
      -- theme
      -- XXX matching keywords and {[], are underlined, not very nice
      -- "Mofiqul/dracula.nvim",
      -- "rafamadriz/neon",
      "folke/tokyonight.nvim",
      -- "andersevenrud/nordic.nvim",
      -- "shaunsingh/nord.nvim",
      -- "Th3Whit3Wolf/one-nvim",
      -- "marko-cerovac/material.nvim",
      -- 'navarasu/onedark.nvim',
      -- {'embark-theme/vim', as = 'embark'},
      -- icons
      "kyazdani42/nvim-web-devicons",
      opt = true,
    },
  })

  -- Add indentation guides to all lines
  use({ "lukas-reineke/indent-blankline.nvim" })
  -- Neovim plugin to improve the default vim.ui interfaces
  use({
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({})
    end,
  })

  -- Notifications, Messages, cmdline, pop up menu
  use({
    "folke/noice.nvim",
    tag = "v1.*",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  })
  use({
    "rcarriga/nvim-notify",
    tag = "v3.*",
  })

  -- a fast and fully programmable greeter for neovim.
  use({
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
        dashboard.button("SPC s f", "  Find file"),
        dashboard.button("SPC s r", "  Recently opened files"),
        dashboard.button("SPC s t", "  Find text"),
        dashboard.button("SPC s p", "  Jump to project"),
        dashboard.button("SPC s s", "  Find old sessions"),
      }
      local handle = io.popen("fortune")
      local fortune = handle:read("*a")
      handle:close()
      dashboard.section.footer.val = fortune
      dashboard.config.opts.noautocmd = true
      vim.cmd([[autocmd User AlphaReady echo 'ready']])
      alpha.setup(dashboard.config)
    end,
  })

  -- Use neovim to edit textarea in browsers
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  })

  -- Spaw terminals
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup()
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
