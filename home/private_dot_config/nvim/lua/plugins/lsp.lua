-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
return {
  {
    "mason-org/mason.nvim",
    enabled = true,
    opts = function(_, opts)
      local function skip(mason_package)
        if type(opts.ensure_installed) == "table" then
          for i = #opts.ensure_installed, 1, -1 do
            if opts.ensure_installed[i] == mason_package then
              table.remove(opts.ensure_installed, i)
            end
          end
        end
      end
      local function add(mason_package)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, mason_package)
        end
      end
      -- Required for python
      add("debugpy")
      -- Skip packages installed with OS package manager
      -- skip("ansible-lint")
      skip("shfmt")
      skip("black")
      skip("stylua")
      -- TODO: Markdown linter: find or build a package
      skip("marksman")
      -- XXX: Skip brew packages
      if vim.uv.os_uname().sysname:find("Darwin") then
        skip("prettier")
        skip("shellcheck")
        skip("markdownlint-cli2")
        opts.registries = {
          "github:mason-org/mason-registry",
          -- XXX: providing ltex_plus
          "github:visimp/mason-registry",
        }
      end
      -- XXX: Skip packages to be installed with Mason but missing on FreeBSD
      if vim.uv.os_uname().sysname:find("FreeBSD") then
        skip("shellcheck")
        -- TODO: Dockerfile linter: find or build a package
        skip("hadolint")
        skip("tflint")
      end
      if vim.uv.os_uname().sysname:find("Linux") then
        add("lua-language-server")
      end
      if vim.uv.os_uname().sysname:find("FreeBSD") then
        --- Debug for MasonInstall issues
        --- https://github.com/williamboman/mason.nvim?tab=readme-ov-file#default-configuration
        -- log_level = vim.log.levels.DEBUG,
        -- Use a local registry with changes to be merged upstream
        -- https://github.com/mason-org/mason-registry/pull/7535
        -- :MasonInstall --target=freebsd_x64 terraform-ls
        opts.registries = {
          "file:~/code/repos/mason-registry",
          "github:mason-org/mason-registry",
        }
      end
    end,
  },

  -- Improved ltex integration, supporting code actions
  {
    "barreiroleo/ltex_extra.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },

  -- add various LSP to lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      servers = {
        ["*"] = {
          -- add folding range to capabilities
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
        ansiblels = {
          -- TODO: Find or build a package for FreeBSD
          -- mason = vim.uv.os_uname().sysname:find("FreeBSD") ~= nil,
          -- Test using Mason
          mason = true,
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
        -- XXX: no native package on FreeBSD
        bashls = {
          mason = vim.uv.os_uname().sysname:find("FreeBSD") ~= nil,
        },
        -- html = {},
        -- groovyls = {},
        -- groovyls = jit.os:find("BSD") and nil or {},
        -- use LanguageTool via ltex for spell checking
        -- TODO: https://dev.languagetool.org/finding-errors-using-n-gram-data.html
        -- TODO: have cmp do completion using words from the dictionaries
        ltex_plus = {
          -- FIXME: ltex-ls was installed and is working on delamain, but no
          -- more automatically installed. Can be insalled manually:
          -- MasonInstall --target=linux
          -- TODO: Find or build a package for FreeBSD
          mason = vim.uv.os_uname().sysname:find("FreeBSD") ~= nil,
          filetypes = {
            "asciidoc",
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
                ["fr"] = {
                  "APOS_TYP",
                  "FRENCH_WHITESPACE",
                  "FR_SPELLING_RULE",
                  "COMMA_PARENTHESIS_WHITESPACE",
                },
              },
            },
          },
        },
        lua_ls = {
          -- TODO: Find or build a package for FreeBSD
          mason = false,
          autostart = not vim.uv.os_uname().sysname:find("FreeBSD"),
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
        marksman = {
          -- TODO: Find or build a package for FreeBSD
          --  -- XXX: Fix build on FreeBSD
          -- mason = vim.uv.os_uname().sysname:find("FreeBSD"),
          mason = false,
          autostart = not vim.uv.os_uname().sysname:find("FreeBSD"),
        },
        mutt_ls = {
          mason = false,
        },
        perlnavigator = {},
        pyright = {
          mason = false,
        },
        ruff = {
          mason = false,
        },
        texlab = {
          mason = false,
        },
        -- XXX: disabled as it's to beinstalled manually
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#textlsp
        -- textlsp = {},
        yamlls = {
          mason = false,
          -- https://github.com/redhat-developer/yaml-language-server
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
      setup = {
        -- integrate ltex_extra with lazyvim
        -- https://github.com/LazyVim/LazyVim/discussions/403
        ---@diagnostic disable-next-line: unused-local
        ltex_plus = function(_, opts)
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              ---@diagnostic disable-next-line: no-unknown
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "ltex_plus" then
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

  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       fish = { "fish_indent" },
  --       groovy = { "npm_groovy_lint" },
  --       lua = { "stylua" },
  --       markdown = { "prettierd" },
  --       sh = { "shfmt" },
  --       yaml = { "prettierd" },
  --     },
  --   },
  -- },
}
