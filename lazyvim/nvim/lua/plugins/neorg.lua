return {
  -- neorg, org-mode like
  -- https://github.com/nvim-neorg/neorg
  -- Bindings: ~/.local/share/nvim/lazy/neorg/lua/neorg/modules/core/keybinds/keybinds.lua
  -- XXX: issues with building treesitter extension on macos
  -- https://github.com/nvim-neorg/tree-sitter-norg/issues/7
  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- XXX: fix build on macos
    -- https://github.com/nvim-neorg/tree-sitter-norg/issues/7#issuecomment-1542743399
    -- Run using :Lazy build neorg
    build = function()
      local shell = require("nvim-treesitter.shell_command_selectors")
      local install = require("nvim-treesitter.install")

      -- save the original functions
      local select_executable = shell.select_executable
      local compilers = install.compilers

      -- temporarily patch treesitter install logic
      local cc = "clang++ -std=c++11"
      ---@diagnostic disable-next-line: duplicate-set-field
      function shell.select_executable(executables)
        return vim.tbl_filter(function(c) ---@param c string
          return c ~= vim.NIL and (vim.fn.executable(c) == 1 or c == cc)
        end, executables)[1]
      end
      install.compilers = { cc }

      -- install norg parsers
      install.commands.TSInstallSync["run!"]("norg") -- or vim.cmd [[ :TSInstallSync! norg ]]

      -- restore the defaults back
      shell.select_executable = select_executable
      install.compilers = compilers
    end,
    opts = {
      load = {
        -- Load default modules
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = { engine = "nvim-cmp" },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              work = "~/Documents/notes/work",
              home = "~/Documents/notes/home",
            },
          },
        },
      },
    },
  },
}
