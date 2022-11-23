-- https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
-- https://github.com/Clumsy-Coder/dotfiles/commit/e81edc159f3fc9ef189e0300d280461e75732a4b
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

-- Available builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- Check if packate is available using :echo executable("shfmt")

null_ls.setup({
  sources = {
    -- code actions
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,
    -- formatters
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    -- diagnostics
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.alex,
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = { "--config", vim.fn.expand("~/.config/nvim/.markdownlint.json") },
    }),
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.ansiblelint,
    -- null_ls.builtins.diagnostics.checkmake,
    -- null_ls.builtins.diagnostics.write_good,
    -- completion
    -- XXX spell is disabled
    -- null_ls.builtins.completion.spell,
    -- hover
    null_ls.builtins.hover.dictionary, -- dictionary
  },
  diagnostics_format = "[#{c}] #{m} (#{s})",
  -- format file on save
  -- you can reuse a shared lspconfig on_attach callback here
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
  --         vim.lsp.buf.format({ bufnr = bufnr })
  --       end,
  --     })
  --   end
  -- end,
})
