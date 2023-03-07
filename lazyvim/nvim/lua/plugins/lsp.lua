-- Build a table from local nvim dictionary to be used by ltex
-- TODO: check https://github.com/barreiroleo/ltex_extra.nvim
local path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
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
        ansiblels = {},
        bashls = {},
        -- use LanguageTool via ltex for spell checking
        -- TODO: https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
        -- TODO: https://dev.languagetool.org/finding-errors-using-n-gram-data.html
        ltex = {
          settings = {
            ltex = {
              -- trace = { server = 'verbose' },
              -- diagnosticSeverity = "information",
              -- checkFrequency = "save",
              language = "en-GB",
              -- enabled = { "latex", "tex", "bib", "markdown", "text", "mail", "norg" },
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
              },
              disabledRules = {
                en = { "TOO_LONG_SENTENCE" },
                ["en-GB"] = { "TOO_LONG_SENTENCE", "OXFORD_SPELLING_Z_NOT_S" },
                fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
              },
              -- XXX: not supported
              -- https://github.com/valentjn/ltex-ls/issues/124#issuecomment-984313281
              -- dictionary = { ["en-GB"] = { ":" .. vim.fn.stdpath("config") .. "/words.txt" } },
              -- Use vim dictionry
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
    },
  },
}
