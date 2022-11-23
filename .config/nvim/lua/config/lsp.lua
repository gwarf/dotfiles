-- https://github.com/neovim/nvim-lspconfig

local api = vim.api
local diagnostic = vim.diagnostic
local fn = vim.fn
local keymap = vim.keymap
local lsp = vim.lsp
local lspconfig = require("lspconfig")
local utils = require("utils")
local null_ls = require("null-ls")

-- global config for diagnostic
diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
  severity_sort = true,
})

-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

-- To be used to display LSP diagnostic window details when on an error
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

  -- turn off formatting for some lsp, to use the ones from null-ls
  if client.name == 'pyright' or client.name == 'jsonls' then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  map("n", "gd", lsp.buf.definition, { desc = "go to definition" })
  map("n", "<C-]>", lsp.buf.definition)
  map("n", "K", lsp.buf.hover)
  map("n", "<C-k>", lsp.buf.signature_help)
  map("n", "<space>rn", lsp.buf.rename, { desc = "varialbe rename" })
  map("n", "gr", lsp.buf.references, { desc = "show references" })
  map("n", "[d", diagnostic.goto_prev, { desc = "previous diagnostic" })
  map("n", "]d", diagnostic.goto_next, { desc = "next diagnostic" })
  map("n", "<space>q", diagnostic.setqflist, { desc = "put diagnostic to qf" })
  map("n", "<space>ca", lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<space>wa", lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
  map("n", "<space>wr", lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
  map("n", "<space>wl", function()
    vim.inspect(lsp.buf.list_workspace_folders())
  end, { desc = "list workspace folder" })

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
          and #diagnostic.get() > 0
      then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.document_highlight()
      end,
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function()
        lsp.buf.clear_references()
      end,
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end
end

-- Inform LSP server about all the capabilities of nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- ltex-ls
-- https://git.vigoux.giize.com/nvim-config/blob/master/lua/lsp_config.lua
require("ltex-ls").setup({
  on_attach = on_attach,
  capabilities = capabilities,
  use_spellfile = true,
  filetypes = { "latex", "tex", "bib", "markdown", "gitcommit", "text" },
  settings = {
    ltex = {
      checkFrequency = "save",
      enabled = { "latex", "tex", "bib", "markdown" },
      language = "auto",
      diagnosticSeverity = "information",
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "fr",
      },
      disabledRules = {
        en = { "TOO_LONG_SENTENCE" },
        fr = { "APOS_TYP", "FRENCH_WHITESPACE", "FR_SPELLING_RULE", "COMMA_PARENTHESIS_WHITESPACE" },
      },
      dictionary = (function()
        local files = {}
        for _, file in ipairs(vim.api.nvim_get_runtime_file("spell/*.add", true)) do
          local lang = vim.fn.fnamemodify(file, ":t:r:r") -- Because 'spellfile' is .{encoding}.add
          local fullpath = vim.fs.normalize(file, ":p")
          files[lang] = { ":" .. fullpath }
        end

        if files.default then
          for lang, _ in pairs(files) do
            if lang ~= "default" then
              vim.list_extend(files[lang], files.default)
            end
          end
          files.default = nil
        end
        return files
      end)(),
    },
  },
})

lspconfig["yamlls"].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
})

lspconfig["jsonls"].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
})

lspconfig["marksman"].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
})

lspconfig["pyright"].setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

if utils.executable("lua-language-server") then
  lspconfig["sumneko_lua"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
          library = {
            fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
            fn.stdpath("config"),
          },
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
      },
    },
    capabilities = capabilities,
  })
else
  vim.notify("sumneko_lua not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("vim-language-server") then
  lspconfig["vimls"].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 500,
    },
  })
else
  vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("bash-language-server") then
  lspconfig.bashls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ansiblels.lua
lspconfig.ansiblels.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  -- use ansible-lint only via null-ls
  settings = {
    ansible = {
      ansibleLint = {
        enabled = false
      }
    }

  }
})

if utils.executable("clangd") then
  lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 500,
    },
  })
else
  vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
-- https://github.com/Clumsy-Coder/dotfiles/commit/e81edc159f3fc9ef189e0300d280461e75732a4b
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Available builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
-- Check if packate is available using :echo executable("shfmt")

null_ls.setup({
  sources = {
    -- code actions
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,
    -- formatters
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.beautysh,
    null_ls.builtins.formatting.stylua,
    -- diagnostics
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.alex,
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = { "--config", vim.fn.expand("~/.config/nvim/.markdownlint.json") },
    }),
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.ansiblelint,
    null_ls.builtins.diagnostics.zsh,
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
