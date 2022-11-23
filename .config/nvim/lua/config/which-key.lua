local which_key = require("which-key")

which_key.setup({
  window = {
    border = "single", -- none, single, double, shadow
  },
})

-- wk.register({
--   f = {
--     name = "file", -- optional group name
--     f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
--     n = { "New File" }, -- just a label. don't create any mapping
--     e = "Edit File", -- same as above
--     ["1"] = "which_key_ignore",  -- special label to hide it in the popup
--     b = { function() print("bar") end, "Foobar" }, -- you can also pass functions!
--     ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
--   },
-- }, { prefix = "<leader>" })

-- Mapping for normal mode
local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local mappings = {
  [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
  ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
  -- ["f"] = { require("lvim.core.telescope.custom-finders").find_project_files, "Find File" },
  ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
  ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
  s = {
    name = "Search",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    p = {
      "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
  },
  -- Need to add something for trouble
  -- looks like duplicated
  T = {
    name = "Treesitter",
    i = { ":TSConfigInfo<cr>", "Info" },
  },
  b = {
    name = "Buffers",
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers<cr>", "Find" },
    b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
    n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
    -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
    e = {
      "<cmd>BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = {
      "<cmd>BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
  },
  -- d = {
  --   name = "Debug",
  --   t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
  --   b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
  --   c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  --   C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
  --   d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
  --   g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
  --   i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  --   o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  --   u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  --   p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
  --   r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
  --   s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
  --   q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
  --   U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
  -- },
  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    -- r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },
  --
  g = {
    name = "Git",
    --   g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = {
      -- Need to add something for trouble
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff",
    },
  },
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    -- Format file
    f = { "<cmd>lua vim.lsp.buf.format(nil, 10000)<cr>", "Format" },
    -- Format selection
    F = { "<cmd>lua vim.lsp.buf.range_formating()<cr>", "Format selection" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason Info" },
    j = {
      vim.diagnostic.goto_next,
      "Next Diagnostic",
    },
    k = {
      vim.diagnostic.goto_prev,
      "Prev Diagnostic",
    },
    l = { vim.lsp.codelens.run, "CodeLens Action" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
    r = { vim.lsp.buf.rename, "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
  },
}

-- Mapping for visual mode
local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
-- see https://neovim.io/doc/user/map.html#:map-cmd
local vmappings = {
  ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

-- local M = {}
-- M.config = function()
--   lvim.builtin.which_key = {
--     ---@usage disable which-key completely [not recommended]
--     active = true,
--     on_config_done = nil,
--     setup = {
--       plugins = {
--         marks = false, -- shows a list of your marks on ' and `
--         registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
--         -- the presets plugin, adds help for a bunch of default keybindings in Neovim
--         -- No actual key bindings are created
--         presets = {
--           operators = false, -- adds help for operators like d, y, ...
--           motions = false, -- adds help for motions
--           text_objects = false, -- help for text objects triggered after entering an operator
--           windows = false, -- default bindings on <c-w>
--           nav = false, -- misc bindings to work with windows
--           z = false, -- bindings for folds, spelling and others prefixed with z
--           g = false, -- bindings for prefixed with g
--         },
--         spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
--       },
--       icons = {
--         breadcrumb = lvim.icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
--         separator = lvim.icons.ui.BoldArrowRight, -- symbol used between a key and it's label
--         group = lvim.icons.ui.Plus, -- symbol prepended to a group
--       },
--       popup_mappings = {
--         scroll_down = "<c-d>", -- binding to scroll down inside the popup
--         scroll_up = "<c-u>", -- binding to scroll up inside the popup
--       },
--       window = {
--         border = "single", -- none, single, double, shadow
--         position = "bottom", -- bottom, top
--         margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
--         padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
--         winblend = 0,
--       },
--       layout = {
--         height = { min = 4, max = 25 }, -- min and max height of the columns
--         width = { min = 20, max = 50 }, -- min and max width of the columns
--         spacing = 3, -- spacing between columns
--         align = "left", -- align columns left, center or right
--       },
--       hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
--       ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
--       show_help = true, -- show help message on the command line when the popup is visible
--       triggers = "auto", -- automatically setup triggers
--       -- triggers = {"<leader>"} -- or specify a list manually
--       triggers_blacklist = {
--         -- list of mode / prefixes that should never be hooked by WhichKey
--         -- this is mostly relevant for key maps that start with a native binding
--         -- most people should not need to change this
--         i = { "j", "k" },
--         v = { "j", "k" },
--       },
--     },
--
--     opts = {
--       mode = "n", -- NORMAL mode
--       prefix = "<leader>",
--       buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--       silent = true, -- use `silent` when creating keymaps
--       noremap = true, -- use `noremap` when creating keymaps
--       nowait = true, -- use `nowait` when creating keymaps
--     },
--     vopts = {
--       mode = "v", -- VISUAL mode
--       prefix = "<leader>",
--       buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--       silent = true, -- use `silent` when creating keymaps
--       noremap = true, -- use `noremap` when creating keymaps
--       nowait = true, -- use `nowait` when creating keymaps
--     },
--     -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
--     -- see https://neovim.io/doc/user/map.html#:map-cmd
--     vmappings = {
--       ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
--     },
--     mappings = {
--       [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
--       ["w"] = { "<cmd>w!<CR>", "Save" },
--       ["q"] = { "<cmd>lua require('lvim.utils.functions').smart_quit()<CR>", "Quit" },
--       ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
--       ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
--       ["f"] = { require("lvim.core.telescope.custom-finders").find_project_files, "Find File" },
--       ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
--       ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
--       b = {
--         name = "Buffers",
--         j = { "<cmd>BufferLinePick<cr>", "Jump" },
--         f = { "<cmd>Telescope buffers<cr>", "Find" },
--         b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
--         n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
--         -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
--         e = {
--           "<cmd>BufferLinePickClose<cr>",
--           "Pick which buffer to close",
--         },
--         h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
--         l = {
--           "<cmd>BufferLineCloseRight<cr>",
--           "Close all to the right",
--         },
--         D = {
--           "<cmd>BufferLineSortByDirectory<cr>",
--           "Sort by directory",
--         },
--         L = {
--           "<cmd>BufferLineSortByExtension<cr>",
--           "Sort by language",
--         },
--       },
--       d = {
--         name = "Debug",
--         t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
--         b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
--         c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--         C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
--         d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
--         g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
--         i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
--         o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
--         u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
--         p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
--         r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
--         s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
--         q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
--         U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
--       },
--       p = {
--         name = "Packer",
--         c = { "<cmd>PackerCompile<cr>", "Compile" },
--         i = { "<cmd>PackerInstall<cr>", "Install" },
--         r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
--         s = { "<cmd>PackerSync<cr>", "Sync" },
--         S = { "<cmd>PackerStatus<cr>", "Status" },
--         u = { "<cmd>PackerUpdate<cr>", "Update" },
--       },
--
--       -- " Available Debug Adapters:
--       -- "   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
--       -- " Adapter configuration and installation instructions:
--       -- "   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
--       -- " Debug Adapter protocol:
--       -- "   https://microsoft.github.io/debug-adapter-protocol/
--       -- " Debugging
--       g = {
--         name = "Git",
--         g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
--         j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
--         k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
--         l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
--         p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
--         r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
--         R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
--         s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
--         u = {
--           "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
--           "Undo Stage Hunk",
--         },
--         o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
--         b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--         c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
--         C = {
--           "<cmd>Telescope git_bcommits<cr>",
--           "Checkout commit(for current file)",
--         },
--         d = {
--           "<cmd>Gitsigns diffthis HEAD<cr>",
--           "Git Diff",
--         },
--       },
--       l = {
--         name = "LSP",
--         a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
--         d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
--         w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
--         f = { require("lvim.lsp.utils").format, "Format" },
--         i = { "<cmd>LspInfo<cr>", "Info" },
--         I = { "<cmd>Mason<cr>", "Mason Info" },
--         j = {
--           vim.diagnostic.goto_next,
--           "Next Diagnostic",
--         },
--         k = {
--           vim.diagnostic.goto_prev,
--           "Prev Diagnostic",
--         },
--         l = { vim.lsp.codelens.run, "CodeLens Action" },
--         q = { vim.diagnostic.setloclist, "Quickfix" },
--         r = { vim.lsp.buf.rename, "Rename" },
--         s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
--         S = {
--           "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--           "Workspace Symbols",
--         },
--         e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
--       },
--       L = {
--         name = "+LunarVim",
--         c = {
--           "<cmd>edit " .. get_config_dir() .. "/config.lua<cr>",
--           "Edit config.lua",
--         },
--         d = { "<cmd>LvimDocs<cr>", "View LunarVim's docs" },
--         f = {
--           "<cmd>lua require('lvim.core.telescope.custom-finders').find_lunarvim_files()<cr>",
--           "Find LunarVim files",
--         },
--         g = {
--           "<cmd>lua require('lvim.core.telescope.custom-finders').grep_lunarvim_files()<cr>",
--           "Grep LunarVim files",
--         },
--         k = { "<cmd>Telescope keymaps<cr>", "View LunarVim's keymappings" },
--         i = {
--           "<cmd>lua require('lvim.core.info').toggle_popup(vim.bo.filetype)<cr>",
--           "Toggle LunarVim Info",
--         },
--         I = {
--           "<cmd>lua require('lvim.core.telescope.custom-finders').view_lunarvim_changelog()<cr>",
--           "View LunarVim's changelog",
--         },
--         l = {
--           name = "+logs",
--           d = {
--             "<cmd>lua require('lvim.core.terminal').toggle_log_view(require('lvim.core.log').get_path())<cr>",
--             "view default log",
--           },
--           D = {
--             "<cmd>lua vim.fn.execute('edit ' .. require('lvim.core.log').get_path())<cr>",
--             "Open the default logfile",
--           },
--           l = {
--             "<cmd>lua require('lvim.core.terminal').toggle_log_view(vim.lsp.get_log_path())<cr>",
--             "view lsp log",
--           },
--           L = { "<cmd>lua vim.fn.execute('edit ' .. vim.lsp.get_log_path())<cr>", "Open the LSP logfile" },
--           n = {
--             "<cmd>lua require('lvim.core.terminal').toggle_log_view(os.getenv('NVIM_LOG_FILE'))<cr>",
--             "view neovim log",
--           },
--           N = { "<cmd>edit $NVIM_LOG_FILE<cr>", "Open the Neovim logfile" },
--           p = {
--             "<cmd>lua require('lvim.core.terminal').toggle_log_view(get_cache_dir() .. '/packer.nvim.log')<cr>",
--             "view packer log",
--           },
--           P = { "<cmd>edit $LUNARVIM_CACHE_DIR/packer.nvim.log<cr>", "Open the Packer logfile" },
--         },
--         r = { "<cmd>LvimReload<cr>", "Reload LunarVim's configuration" },
--         u = { "<cmd>LvimUpdate<cr>", "Update LunarVim" },
--       },
--       s = {
--         name = "Search",
--         b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--         c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
--         f = { "<cmd>Telescope find_files<cr>", "Find File" },
--         h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
--         H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
--         M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--         r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--         R = { "<cmd>Telescope registers<cr>", "Registers" },
--         t = { "<cmd>Telescope live_grep<cr>", "Text" },
--         k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--         C = { "<cmd>Telescope commands<cr>", "Commands" },
--         p = {
--           "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
--           "Colorscheme with Preview",
--         },
--       },
--       T = {
--         name = "Treesitter",
--         i = { ":TSConfigInfo<cr>", "Info" },
--       },
--     },
--   }
-- end
--
-- M.setup = function()
--   local which_key = require "which-key"
--
--   which_key.setup(lvim.builtin.which_key.setup)
--
--   local opts = lvim.builtin.which_key.opts
--   local vopts = lvim.builtin.which_key.vopts
--
--   local mappings = lvim.builtin.which_key.mappings
--   local vmappings = lvim.builtin.which_key.vmappings
--
--   which_key.register(mappings, opts)
--   which_key.register(vmappings, vopts)
--
--   if lvim.builtin.which_key.on_config_done then
--     lvim.builtin.which_key.on_config_done(which_key)
--   end
-- end
--
-- return M
