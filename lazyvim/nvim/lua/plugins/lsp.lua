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
}
