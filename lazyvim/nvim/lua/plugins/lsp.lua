-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
return {
  -- Restore 'gw' to default behavior. First, remove the 'gw' keymap set in LazyVim:
  -- vim.keymap.del({ "n", "x" }, "gw")
  -- Then, reset formatexpr if null-ls is not providing any formatting generators.
  -- See: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
  -- require("lazyvim.util").on_attach(function(client, buf)
  --   if client.name == "null-ls" then
  --     if not require("null-ls.generators").can_run(vim.bo[buf].filetype, require("null-ls.methods").lsp.FORMATTING) then
  --       vim.bo[buf].formatexpr = nil
  --     end
  --   end
  -- end),

  -- Improved ltex integration, supporting code actions
  { "barreiroleo/ltex-extra.nvim" },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
    -- XXX: Need to run master as current tagged release is broken and not using latest lua_ls
    -- name, cf https://github.com/neovim/nvim-lspconfig/pull/2439
    version = false,
    opts = {
      -- add folding range to capabilities
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      -- suppress virtual text
      diagnostics = {
        virtual_text = false,
      },
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      servers = {
        ansiblels = {},
        bashls = {},
        -- use LanguageTool via ltex for spell checking
        -- TODO: https://dev.languagetool.org/finding-errors-using-n-gram-data.html
        ltex = {
          filetypes = {
            "bib",
            "gitcommit",
            "latex",
            "mail",
            "markdown",
            "norg",
            "org",
            "pandoc",
            "rst",
            "text",
          },
          settings = {
            -- https://valentjn.github.io/ltex/settings.html
            ltex = {
              -- trace = { server = 'verbose' },
              -- checkFrequency = "save",
              language = "en-GB",
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
              },
              -- https://community.languagetool.org/rule/list?lang=en
              disabledRules = {
                en = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S", "DASH_RULE" },
                ["en-GB"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S", "DASH_RULE" },
                fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
              },
            },
          },
        },
        pyright = {},
        rnix = {
          -- rnix-lsp is installed using nix
          mason = false,
        },
      },
      setup = {
        -- integrate ltex_extra with lazyvim
        -- https://github.com/LazyVim/LazyVim/discussions/403
        ltex = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "ltex" then
                require("ltex_extra").setup({
                  load_langs = { "en-GB", "fr" }, -- languages for witch dictionaries will be loaded
                  init_check = true, -- whether to load dictionaries on startup
                  path = vim.fn.stdpath("config") .. "/spell", -- path to store dictionaries.
                  log_level = "none", -- "none", "trace", "debug", "info", "warn", "error", "fatal"
                })
              end
            end,
          })
        end,
      },
    },
  },

  -- customise null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local utils = require("null-ls.utils")
      local flake8_extra_args = {}
      local root = utils.get_root()
      local flake8_conf = root .. "/.github/linters/.flake8"
      -- Load configuration file from super-liner, if any
      if vim.loop.fs_stat(flake8_conf) then
        flake8_extra_args = { "--config", flake8_conf }
      else
        -- Align with black
        -- https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html#flake8
        flake8_extra_args = { "--max-line-length", "88", "--extend-ignore", "E203,W503" }
      end
      local custom_sources = {
        -- Copy default sources list
        nls.builtins.formatting.fish_indent,
        nls.builtins.diagnostics.fish,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt,
        nls.builtins.diagnostics.flake8.with({
          extra_args = flake8_extra_args,
        }),
      }
      -- XXX: Works but replaces default configuration
      opts.sources = custom_sources
      -- XXX: when added back flake8 is not workign
      -- opts.sources = vim.tbl_filter(function(source)
      --   return source.name ~= "flake8"
      -- end, opts.sources)
      -- vim.tbl_extend("force", opts.sources, custom_sources)
      -- XXX: Duplicates flake8 configuration, would need a name on the source to filder
      -- it using register/is_registered
      -- vim.tbl_extend("error", opts.sources, custom_sources)
      -- vim.list_extend("error", opts.sources, custom_sources)
      -- nls.deregister({ name = "flake8" })
      -- nls.disable({ name = "flake8" })
      -- nls.register({
      --   name = "flake8",
      --   nls.builtins.diagnostics.flake8.with({
      --     extra_args = flake8_extra_args,
      --   }),
      -- })
      -- nls.enable({ name = "flake8" })
      ---@diagnostic disable-next-line: missing-parameter
      -- XXX: error from null-ls:
      -- ...cal/share/nvim/lazy/null-ls.nvim/lua/null-ls/sources.lua:203: attempt to index local 'generator' (a nil value)
      -- vim.list_extend(opts.sources, custom_sources)
      ---@diagnostic disable-next-line: missing-parameter
      -- opts.sources = vim.tbl_deep_extend("force", opts.sources, custom_sources)
    end,
  },
}
