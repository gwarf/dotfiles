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

  -- Install treesitter-aware fork of dracula theme
  { "Mofiqul/dracula.nvim" },

  -- Install ltex-ls for spellchecking
  { "vigoux/ltex-ls.nvim" },

  -- Override LazyVim configuration
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
      -- colorscheme = "catppuccin-frappe",
      -- colorscheme = function()
      --   require("tokyonight").load({ style = "storm" })
      -- end,
    },
  },

  -- Install support for editing nix files
  { "LnL7/vim-nix" },

  -- add vim-repeat to supercharge .
  { "tpope/vim-repeat" },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
    -- Need to run master as current tagged release is broken and not using latest lua_ls
    -- name, cf https://github.com/neovim/nvim-lspconfig/pull/2439
    -- https://www.lazyvim.org/configuration/lazy.nvim
    version = false,
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
        -- use LanguageTool for spell checking
        -- TODO: https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
        -- TODO: https://dev.languagetool.org/finding-errors-using-n-gram-data.html
        ltex = {
          checkFrequency = "save",
          enabled = { "latex", "tex", "bib", "markdown", "text", "mail", "norg" },
          language = "en-GB",
          diagnosticSeverity = "information",
          additionalRules = {
            enablePickyRules = true,
            motherTongue = "fr",
          },
          disabledRules = {
            en = { "TOO_LONG_SENTENCE" },
            ["en-GB"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S" },
            fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
          },
          dictionary = { ["en-GB"] = { ":" .. vim.fn.stdpath("config") .. "/words.txt" } },
        },
      },
    },
  },

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
