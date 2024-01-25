-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/coding.lua
return {
  -- Install support for editing nix files
  { "LnL7/vim-nix" },

  -- TODO: check if useful and incorporate if needed
  -- https://github.com/AckslD/nvim-FeMaco.lua

  -- Go forward/backward with square brackets
  {
    "echasnovski/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")

      local function put(cmd, regtype)
        local body = vim.fn.getreg(vim.v.register)
        local type = vim.fn.getregtype(vim.v.register)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.fn.setreg(vim.v.register, body, regtype or "l")
        ---@diagnostic disable-next-line: missing-parameter
        bracketed.register_put_region()
        vim.cmd(('normal! "%s%s'):format(vim.v.register, cmd:lower()))
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.fn.setreg(vim.v.register, body, type)
      end

      for _, cmd in ipairs({ "]p", "[p" }) do
        vim.keymap.set("n", cmd, function()
          put(cmd)
        end)
      end
      for _, cmd in ipairs({ "]P", "[P" }) do
        vim.keymap.set("n", cmd, function()
          put(cmd, "c")
        end)
      end

      local put_keys = { "p", "P" }
      for _, lhs in ipairs(put_keys) do
        vim.keymap.set({ "n", "x" }, lhs, function()
          return bracketed.register_put_region(lhs)
        end, { expr = true })
      end

      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- improved %
  {
    "andymass/vim-matchup",
    -- XXX: Need to run master as tagged release is outdated
    version = false,
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  -- A better annotation generator
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  -- Incremental LSP renaming
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  -- Structural search and replace
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sR",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },

  -- Refactoring library based off the Refactoring book by Martin Fowler
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          ---@diagnostic disable-next-line: assign-type-mismatch
          augend.date.alias["%Y/%m/%d"],
          ---@diagnostic disable-next-line: assign-type-mismatch
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },

  -- Use <tab> for completion and snippets (supertab).
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  -- see ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/coding.lua
  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      { "codybuell/cmp-lbdb", lazy = true, ft = "mail" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-cmdline" },
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

      ---@diagnostic disable-next-line: missing-parameter
      -- FIXME: only add emoji and overwrite buffer configuration instead of replicating
      -- configuration
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path" },
        { name = "emoji" },
        -- XXX: disabled until there is a way to opt-in for copilot in special cases
        -- { name = "copilot" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      })

      -- FIXME: not working, causing issues with load of cmp in some cases
      -- Filter out copilot from some use cases, like emails to preserve privacy
      -- local limited_sources = {}
      -- for i = #opts.sources, 1, -1 do
      --   if opts.sources[i].name ~= "copilot" then
      --     table.insert(limited_sources, opts.sources[i])
      --   end
      -- end
      -- Do not use copilot in norg and markdown files
      -- cmp.setup.filetype({"norg", "markdown}", {
      --   ---@diagnostic disable-next-line: missing-parameter
      --   sources = cmp.config.sources(limited_sources),
      -- })

      -- only load lbdb completion for emails
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("mail", {
        ---@diagnostic disable-next-line: missing-parameter
        sources = cmp.config.sources({
          -- would be useful to be able to use this only when completing headers
          { name = "lbdb" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "emoji" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
      })

      -- Add neorg
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("norg", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "neorg" },
          { name = "path" },
          { name = "emoji" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- `/` cmdline setup.
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Custom snippets
      -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
      ---@diagnostic disable-next-line: no-unknown
      local s = luasnip.snippet
      ---@diagnostic disable-next-line: no-unknown
      local i = luasnip.insert_node
      ---@diagnostic disable-next-line: no-unknown
      local t = luasnip.text_node
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
      })
    end,
  },

  -- supercharged .
  -- makes some plugins dot-repeatable
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- Use the w, e, b motions like a spider. Considers camelCase and skips insignificant punctuation.
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w" },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e" },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b" },
    },
  },

  -- Open links without netrw using gx mapping
  { "chrishrb/gx.nvim" },
}
