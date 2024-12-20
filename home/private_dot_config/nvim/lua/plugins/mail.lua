-- Loading CMP source in blink using https://github.com/Saghen/blink.compat
-- derived from https://github.com/LazyVim/LazyVim/blob/c1ee761dd88ec71fa9c9eb9706828598e7522c5d/lua/lazyvim/plugins/extras/ai/tabnine.lua#L40
-- FIXME: configuration à la using LazyVim
return {

  { "codybuell/cmp-lbdb" },
  {
    "saghen/blink.cmp",
    -- optional = true,
    dependencies = {
      "codybuell/cmp-lbdb",
      "saghen/blink.compat",
    },
    opts = {
      sources = {
        compat = { "lbdb" },
        providers = {
          lbdb = {
            name = "lbdb",
          },
        },
      },
    },
  },
}

-- XXX: na5tive configuration
-- return {
--   -- add blink.compat
--   -- {
--   --   "saghen/blink.compat",
--   --   lazy = true,
--   --   opts = {},
--   -- },
--
--   {
--     "saghen/blink.cmp",
--     dependencies = {
--       -- add source
--       { "codybuell/cmp-lbdb" },
--     },
--     sources = {
--       completion = {
--         -- remember to enable your providers here
--         enabled_providers = { "lsp", "path", "snippets", "buffer", "lbdb" },
--       },
--
--       providers = {
--         -- create provider
--         lbdb = {
--           name = "lbdb",
--           module = "blink.compat.source",
--
--           -- all blink.cmp source config options work as normal:
--           score_offset = -3,
--
--           -- this table is passed directly to the proxied completion source
--           -- as the `option` field in nvim-cmp's source config
--           --
--           -- this is NOT the same as the opts in a plugin's lazy.nvim spec
--           opts = {},
--         },
--       },
--     },
--   },
-- }
