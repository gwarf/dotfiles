-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
return {
  -- Improved ltex integration, supporting code actions
  {
    "barreiroleo/ltex_extra.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
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
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      servers = {
        ansiblels = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("roles", "playbooks")(fname)
              or require("lspconfig.util").root_pattern("ansible.cfg", ".ansible-lint")(fname)
              or require("lspconfig.util").find_git_ancestor(fname)
          end,
          settings = {
            ansible = {
              validation = {
                lint = {
                  arguments = "--warn-list role-name[path]",
                },
              },
            },
          },
        },
        bashls = {},
        -- dockerls = {},
        -- html = {},
        -- groovyls = {},
        -- use LanguageTool via ltex for spell checking
        -- TODO: https://dev.languagetool.org/finding-errors-using-n-gram-data.html
        -- TODO: have cmp do completion using words from the dictionaries
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
            "tex",
            "text",
          },
          settings = {
            -- https://valentjn.github.io/ltex/settings.html
            ltex = {
              -- trace = { server = "verbose" },
              -- XXX: unwanted checks are still occurring, often delaying CodeActions
              checkFrequency = "save",
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
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        marksman = {},
        -- Do not install nil_ls with Mason
        nil_ls = {
          mason = false,
        },
        perlnavigator = {
          -- settings = {
          --   perlnavigator = {
          --     perlPath = "/usr/local/bin/perl",
          --   },
          -- },
        },
        pyright = {},
        texlab = {},
        -- XXX: disabled as it's to beinstalled manually
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#textlsp
        -- textlsp = {},
        yamlls = {
          -- https://github.com/redhat-developer/yaml-language-server
          settings = {
            yaml = {
              keyOrdering = false,
              -- XXX: not working/not needed?
              -- format = { enable = true },
              -- validate = true,
            },
          },
        },
        -- vimls = {},
      },
      setup = {
        -- integrate ltex_extra with lazyvim
        -- https://github.com/LazyVim/LazyVim/discussions/403
        ---@diagnostic disable-next-line: unused-local
        ltex = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              ---@diagnostic disable-next-line: no-unknown
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

  -- Replacement for formatting via null-ls/none-ls
  {
    -- XXX: auto format not working with prettier but only with prettierd?!
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettierd" },
        yaml = { "prettierd" },
        groovy = { "npm_groovy_lint" },
      },
      formatters = {
        -- FIXME: too slow, the formatter should be installed locally
        -- npm_groovy_lint = {
        --   -- command = "npm-groovy-lint",
        --   command = "docker",
        --   -- FIXME: latest version is currently broken 2023-11-15
        --   -- https://github.com/nvuillam/npm-groovy-lint/issues/319
        --   args = { "run", "--rm", "nvuillam/npm-groovy-lint:11.1.1", "--format", "--files", "$FILENAME" },
        --   stdin = false,
        --   condition = function(ctx)
        --     return vim.fs.basename(ctx.filename) == "Jenkinsfile"
        --   end,
        -- },
      },
    },
  },

  -- {
  -- FIXME: to be dropped once incorporated in my conform.nvim and nvim-lint setup
  --   "nvimtools/none-ls.nvim",
  --   -- https://github.com/LazyVim/LazyVim/discussions/1522#discussioncomment-7153402
  --   enabled = false,
  --   opts = function(_, opts)
  --     ---@diagnostic disable-next-line: no-unknown
  --     local nls = require("null-ls")
  --     ---@diagnostic disable-next-line: no-unknown
  --     local utils = require("null-ls.utils")
  --     -- local flake8_extra_args = {}
  --     ---@diagnostic disable-next-line: no-unknown
  --     local root = utils.get_root()
  --     -- local flake8_conf = root .. "/.github/linters/.flake8"
  --     -- Load configuration file from super-liner, if any
  --     -- if vim.loop.fs_stat(flake8_conf) then
  --     --   flake8_extra_args = { "--config", flake8_conf }
  --     -- else
  --     --   -- Align with black
  --     --   -- https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html#flake8
  --     --   flake8_extra_args = { "--max-line-length", "88", "--extend-ignore", "E203,W503" }
  --     -- end
  --     -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  --     opts.sources = {
  --       -- Shell
  --       nls.builtins.formatting.shfmt,
  --       -- text
  --       nls.builtins.diagnostics.alex,
  --       nls.builtins.hover.dictionary,
  --       nls.builtins.diagnostics.checkmake,
  --       nls.builtins.diagnostics.write_good,
  --       -- perl
  --       nls.builtins.formatting.perltidy,
  --       -- python
  --       -- nls.builtins.formatting.isort.with({
  --       --   extra_args = { "--profile", "black" },
  --       -- }),
  --       -- nls.builtins.formatting.black,
  --       -- nls.builtins.diagnostics.flake8.with({
  --       --   extra_args = flake8_extra_args,
  --       -- }),
  --     }
  --   end,
  -- },
}
