-- TODO: Properly integrate https://github.com/barreiroleo/ltex_extra.nvim
-- Build a table from local dictionary to be used by ltex
local path = vim.fn.stdpath("config") .. "/spell/ltex.dictionary.en-GB.txt"
local words = {}

local f = io.open(path, "r")
if f ~= nil then
  for word in f:lines() do
    table.insert(words, word)
  end
else
  print("No spell folder in ", path)
end

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
      -- suppres virtual text
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
                en = { "TOO_LONG_SENTENCE", "DASH_RULE" },
                ["en-GB"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S", "DASH_RULE" },
                fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
              },
              -- XXX: Using an external dictionary file is currently not supported
              -- https://github.com/valentjn/ltex-ls/issues/124#issuecomment-984313281
              -- dictionary = { ["en-GB"] = { ":" .. vim.fn.stdpath("config") .. "/words.txt" } },
              -- FIXME: rely on list generated from dictionary built by ltex_extra
              dictionary = { ["en-GB"] = words },
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
        -- FIXME: try to integrate ltex_extra with lazyvom
        -- ltex_extra fails with: Error catching ltex client
        -- the words are added to the dict, but not loaded by ltex
        ltex = function(_, opts)
          require("ltex_extra").setup({
            load_langs = { "en-GB", "fr" }, -- languages for witch dictionaries will be loaded
            init_check = true, -- whether to load dictionaries on startup
            path = vim.fn.stdpath("config") .. "/spell", -- path to store dictionaries.
            log_level = "none", -- "none", "trace", "debug", "info", "warn", "error", "fatal"
          })
        end,
      },
    },
  },
}
