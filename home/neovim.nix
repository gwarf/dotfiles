# https://srid.ca/cli/neovim/install
{ pkgs, inputs, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in
{
  imports = [
    ./lsp.nix
  ];

  programs.neovim = {
    enable = true;
    package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      popup-nvim
      nvim-web-devicons
      vim-numbertoggle
      {
        plugin = tokyonight-nvim;
        config = ''
          set background=dark
          colorscheme tokyonight
        '';
      }
      {
        plugin = lessspace-vim;
        config = "let g:lessspace_blacklist = ['diff', 'mail']";
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup({})
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = {
              theme = "tokyonight",
            },
            sections = {
              lualine_c = {
                "filename",
                "lsp_progress"
              },
              lualine_x = {
                "encoding",
                "fileformat",
                "filetype"
              }
            }
          })
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        # XXX find a way to specify a specific plugin version
        # tag = "v3.*";
        config = ''
          require("bufferline").setup({
            options = {
              show_close_icon = false,
              custom_filter = function(buf, buf_nums)
                -- Hide quickfix lists from bufferline
                return vim.bo[buf].buftype ~= "quickfix"
              end,
              offsets = {
                {
                  filetype = "NvimTree",
                  text = vim.fn.getcwd
                }
              }
            }
          })
          -- Navigate buffers
          local opts = { noremap = true, silent = true }
          vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
          vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
        '';
      }
      {
        plugin = wilder-nvim;
        config = "call wilder#setup({'modes': [':', '/', '?']})";
      }
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = ''require("neoscroll").setup({})'';
      }
      editorconfig-nvim
      vim-sleuth
      {
        plugin = camelcasemotion;
        config = "let g:camelcasemotion_key = '\\'";
      }
      {
        plugin = suda-vim;
        config = "let g:suda_smart_edit = 1";
      }
      nvim-ts-rainbow
      {
        plugin = nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars);
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = {
              enable = true,
              disable = { "latex" },
            },
            incremental_selection = { enable = true },
            indentation = { enable = true },
            folding = { enable = true },
            -- rainbow parenthesis match
            rainbow = {
              enable = true,
              extended_mode = true, -- Also highlight non-bracket delimiters
              max_file_lines = nil
            }
          })
        '';
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''require("colorizer").setup({})'';
      }
      # Manage undo
      undotree
      # vim-mundo
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      # telescope-termfinder
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require("telescope")
          telescope.load_extension("file_browser")
          telescope.load_extension("projects")
          telescope.load_extension("fzf")
          -- telescope.load_extension("termfinder")
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("gitsigns").setup({})'';
      }
      # open last position in file
      vim-lastplace
      {
        plugin = project-nvim;
        type = "lua";
        config = ''
          require("project_nvim").setup({
              -- :ProjectRoot is required to switch project
              manual_mode = true,
              silent_chdir = false,
          })
        '';
      }
      {
        # Catalyze Fenced Markdown Code-block editing!
        plugin = pkgs.nur.repos.m15a.vimExtraPlugins.nvim-FeMaco-lua;
        type = "lua";
        config = ''require("femaco").setup({})'';
      }
      lualine-lsp-progress
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          local wk = require("which-key")
          wk.setup {
            spelling = {
              enabled = true,
              suggestions = 10
            },
            window = {
              margin = {0, 0, 0, 0},
              padding = {1, 0, 1, 0,}
            }
          }
          local map = function (from, to, ...)
            return {
              from, to, ...,
              noremap = true,
              silent = true
            }
          end
          wk.register (
            {
              f = {
                name = "Find",
                r = map ("<cmd>Telescope resume<cr>", "Resume saerch"),
                f = map ("<cmd>Telescope find_files<cr>", "Files"),
                g = map ("<cmd>Telescope live_grep<cr>", "Grep"),
                b = map ("<cmd>Telescope buffers<cr>", "Buffers"),
                h = map ("<cmd>Telescope help_tags<cr>", "Help"),
                p = map ("<cmd>Telescope projects<cr>", "Projects"),
                e = map ("<cmd>Telescope file_browser<cr>", "Explore"),
                t = map ("<cmd>NvimTreeToggle<cr>", "File tree"),
                -- ["\\"] = map ("<cmd>Telescope termfinder find<cr>", "Terminals"),
                [":"] = map ("<cmd>Telescope commands<cr>", "Commands"),
                a = map ("<cmd>Telescope<cr>", "All telescopes"),
              },
              c = {
                name = "Code",
                e = map ("<cmd>FeMaco<cr>", "Edit fenced block"),
              },
              g = {
                name = "Git",
                g = map ("<cmd>Lazygit<cr>", "Lazygit"),
              },
              r = {
                name = "Reload",
                r = map ("<cmd>e<cr>", "File"),
                c = map ("<cmd>source ~/.config/nvim/init.vim<cr>", "Config"),
              },
              t = {
                name = "Table",
                m = "Toggle table mode",
                t = "To table"
              },
              u = map ("<cmd>UndotreeToggle<cr>", "Undo tree"),
            },
            { prefix = "<leader>" }
          )
          wk.register {
            ["]b"] = map ("<cmd>BufferLineCycleNext<cr>", "Next buffer"),
            ["]B"] = map ("<cmd>BufferLineMoveNext<cr>", "Move buffer right"),
            ["[b"] = map ("<cmd>BufferLineCyclePrev<cr>", "Previous buffer"),
            ["[B"] = map ("<cmd>BufferLineMovePrev<cr>", "Move buffer left"),
            gb = map ("<cmd>BufferLinePick<cr>", "Go to buffer"),
            gB = map ("<cmd>BufferLinePickClose<cr>", "Close picked buffer"),
          }
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        # tag = "nightly";
        config = ''
          require("nvim-tree").setup({})
          vim.keymap.set("n", "<leader>T", "<cmd>NvimTreeToggle<cr>", { silent = true, noremap = true })
        '';
      }
      {
        plugin = lsp_signature-nvim;
        type = "lua";
        config = ''require"lsp_signature".setup({})'';
      }
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-buffer
      cmp-cmdline
      cmp-emoji
      cmp_luasnip
      # {
      #   plugin = (pkgs.vimUtils.buildVimPlugin {
      #     # Neovim completion library for sumneko/lua-language-server
      #     name = "emmylua-nvim";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "ii14";
      #       repo = "emmylua-nvim";
      #       rev = "a220650fd6ef6490a787eb7efcab24b4bf13dab8";
      #       # sha256 = "J/j7pyvqdSfQUkcXw0krvw303N+FlgDN+wH0bAefOYw=";
      #     };
      #   });
      # }
      friendly-snippets
      {
        plugin = pkgs.nur.repos.m15a.vimExtraPlugins.lspkind-nvim;
      }
      {
        plugin = pkgs.nur.repos.m15a.vimExtraPlugins.LuaSnip;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          cmp.setup {
            snippet = {
              expand = function (args)
                luasnip.lsp_expand(args.body)
              end
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = {
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),
              ["<C-u>"] = cmp.mapping.scroll_docs(-4),
              ["<C-d>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.close(),
              ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
              },
              ["<Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                else
                  fallback()
                end
              end,
              ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                  fallback()
                end
              end
            },
            sources = {
              { name = "luasnip" },
              {
                name = "buffer",
                option = {
                  get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                  end,
                },
              },
              { name = "path" },
              { name = "emoji", insert = true },
              { name = "nvim_lsp" },
            }
          }
        '';
      }
    ];

    extraConfig = ''
      set termguicolors     " Enable gui colors
      set cursorline        " Enable highlighting of the current line
      set signcolumn=yes    " Always show signcolumn or it would frequently shift
      set pumheight=10      " Make popup menu smaller
      set cmdheight=0       " Automatically hide command line
      set colorcolumn=+1    " Draw colored column one step to the right of desired maximum width
      set linebreak         " Wrap long lines at 'breakat' (if 'wrap' is set)
      set scrolloff=2       " Show more lines on top and bottom
      set title             " Enable window title
      set list              " Show tabs and trailing spaces
      set number          " Show line numbers
      set relativenumber  " Show relative line numbers
      set numberwidth=1   " Minimum number width
      set noshowmode
      set whichwrap=b,s,h,l,<,>,[,] " Allow moving along lines when the start/end is reached
      set clipboard=unnamedplus     " Sync yank register with system clipboard
      set expandtab     " Convert tabs to spaces
      set tabstop=2     " Display 2 spaces for a tab
      set shiftwidth=2  " Use this number of spaces for indentation
      set smartindent   " Make indenting smart
      set autoindent    " Use auto indent
      set breakindent   " Indent wrapped lines to match line start
      set virtualedit=block
      set formatlistpat=^\\s*\\w\\+[.\)]\\s\\+\\\\|^\\s*[\\-\\+\\*]\\+\\s\\+
      set foldmethod=indent  " Set 'indent' folding method
      set nofoldenable       " Start with folds opened
      let g:mapleader = ' '
      let g:maplocalleader = ' '
      " use return to enter command mode
      nnoremap <cr> :
      vnoremap <cr> :
      set mouse=      " Disable mouse
      set lazyredraw  " Use lazy redraw
      set undofile    " Enable persistent undo
      set hidden      " Allow buffers in background
      set ignorecase " Enable case insensitive search
      set smartcase  " when using uppercase make case sensitive
      set incsearch  " Show search results while typing
      " let $GIT_EDITOR = 'nvr -cc split --remote-wait'
      autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
      " disable spell by default
      set nospell
      set spelllang=en,fr     " Define spelling dictionaries
      set complete+=kspell    " Add spellcheck options for autocomplete
      set spelloptions=camel  " Treat parts of camelCase words as separate words
      set completeopt=menu,menuone,noselect
      " XXX when adding a quote there, it's autopaired, which is useless as we are in vimscript, and it's the comment
      " Highlight problematic whitespace
      set list
      set listchars="tab:>.,trial:.,exteands:#,nbsp:."
      " Create new window below current one, and on the right
      set splitbelow
      set splitright
    '';
  };

  # Load LSP servers
  nvimLSP.rnix = rec {
    package = pkgs.rnix-lsp;
  };
  nvimLSP.yamlls = rec {
    package = pkgs.nodePackages.yaml-language-server;
  };
  nvimLSP.pyright = pkgs.nodePackages.pyright;
  nvimLSP.sumneko_lua = rec {
    package = pkgs.sumneko-lua-language-server;
    config = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT";
          };
          diagnostics = {
            # Get the language server to recognize the `vim` global
            globals = [ "vim" ];
          };
        };
      };
    };
  };
}
