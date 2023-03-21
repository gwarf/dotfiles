-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
return {
  -- Restore 'gw' to default behavior. First, remove the 'gw' ()searching for a word) keymap set in LazyVim:
  -- FIXME: keympa not found
  -- vim.keymap.del({ "n", "x" }, "gw"),
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
      -- Manage virtual text
      diagnostics = {
        virtual_text = true,
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
              -- trace = { server = "verbose" },
              -- checkFrequency = "save",
              language = "en-GB",
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
              },
              -- https://community.languagetool.org/rule/list?lang=en
              disabledRules = {
                -- en-GB disabled rules loaded from ~/.config/nvim/spell/ltex.disabledRules.en-GB.txt
                ["fr"] = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
              },
            },
          },
        },
        marksman = {},
        pyright = {},
        rnix = {
          -- rnix-lsp is installed using nix
          mason = false,
        },
        yamlls = {},
      },
      setup = {
        -- integrate ltex_extra with lazyvim
        -- https://github.com/LazyVim/LazyVim/discussions/403
        ---@diagnostic disable-next-line: unused-local
        ltex = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "ltex" then
                require("ltex_extra").setup({
                  load_langs = { "en-GB", "fr" }, -- languages for witch dictionaries will be loaded
                  init_check = true, -- whether to load dictionaries on startup
                  path = vim.fn.stdpath("config") .. "/spell", -- path to store dictionaries.
                  log_level = "error", -- "none", "trace", "debug", "info", "warn", "error", "fatal"
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
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      opts.sources = {
        -- fish
        nls.builtins.diagnostics.fish,
        nls.builtins.formatting.fish_indent,
        -- zsh
        nls.builtins.diagnostics.zsh,
        -- shell
        nls.builtins.formatting.shfmt,
        -- text
        nls.builtins.diagnostics.alex,
        nls.builtins.hover.dictionary,
        nls.builtins.diagnostics.checkmake,
        nls.builtins.diagnostics.write_good,
        -- lua
        nls.builtins.formatting.stylua,
        -- python
        nls.builtins.formatting.isort,
        nls.builtins.formatting.black,
        nls.builtins.diagnostics.flake8.with({
          extra_args = flake8_extra_args,
        }),
        -- Injects code actions for Git operations at the current cursor position
        nls.builtins.code_actions.gitsigns,
      }
    end,
  },
}
