-- Example: https://github.com/folke/dot/tree/master/config/nvim
-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins

-- https://sbulav.github.io/vim/neovim-setting-up-luasnip/
local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end
local s = luasnip.snippet
local i = luasnip.insert_node
local t = luasnip.text_node

return {
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-macchiato",
      colorscheme = "catppuccin-frappe",
      -- colorscheme = function()
      --   require("tokyonight").load({ style = "storm" })
      -- end,
    },
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add telescope-fzf-native
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    -- apply the config and additionally load fzf-native
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      servers = {
        pyright = {},
        ansiblels = {},
        bashls = {},
        rnix = {
          -- rnix-lsp is installed using nix
          mason = false,
        },
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim.
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add jsonls and schemastore ans setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- XXX tools are managed via nix
  -- add any tools you want to have installed below
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "stylua",
  --       "shellcheck",
  --       "shfmt",
  --       "flake8",
  --     },
  --   },
  -- },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        { name = "emoji", insert = true },
      }))
    end,
  },

  -- org-mode like
  -- https://github.com/nvim-neorg/neorg
  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- after = "nvim-treesitter", -- You may want to specify Telescope here as well
    -- run = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup({
        load = {
          -- Load everything
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = {
            config = { engine = "nvim-cmp" },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "~/Documents/notes/work",
                home = "~/Documents/notes/home",
              },
            },
          },
        },
      })
    end,
  },

  -- Custom snippets
  -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
  -- XXX move this to a dedicated file
  luasnip.add_snippets("all", {
    s("ternary", {
      -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
      i(1, "cond"),
      t(" ? "),
      i(2, "then"),
      t(" : "),
      i(3, "else"),
    }),
    s("brb", { t({ "Best regards,", "Baptiste" }) }),
    s("cb", { t({ "Cheers,", "Baptiste" }) }),
  }),
}
