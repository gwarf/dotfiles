# https://srid.ca/cli/neovim/install
{  pkgs, inputs, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in
{
  programs.neovim = {
    enable = true;
    package = neovim-nightly;
    vimAlias = true;
    viAlias = true;
    # XXX does not exist?
    # defaultEditor = true;

    extraPackages = [
    ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      vim-numbertoggle
      {
        plugin = tokyonight-nvim;
        config = ''
          set background=dark
          colorscheme tokyonight
          '';
      }
      lualine-lsp-progress
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = {
              theme = "tokyonight",
              section_separators = {
                left = "",
                right = ""
              },
              component_separators = {
                 left = "|",
                 right = "|"
              },
            },
            sections = {
              lualine_c = {
                "filename",
                "lsp_progress"
              },
              lualine_x = {
                "encoding",
                "fileformat",
                function ()
                  if vim.o.expandtab then
                    return vim.o.shiftwidth .. " ␣"
                  else
                    return vim.o.tabstop .. " ↹"
                  end
                end,
                "filetype"
              }
            }
          })
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup {
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
          }
        '';
      }
      {
        plugin = wilder-nvim;
        config = "call wilder#setup({'modes': [':', '/', '?']})";
      }
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = ''require"neoscroll".setup{}'';
      }
      editorconfig-nvim
      vim-sleuth
      {
        plugin = camelcasemotion;
        config = "let g:camelcasemotion_key = '\\'";
      }
      # {
      #   plugin = (vimUtils.buildVimPlugin {
      #     name = "vim-fanfingtastic";
      #     src = fetchFromGitHub {
      #       owner = "dahu";
      #       repo = "vim-fanfingtastic";
      #       rev = "6d0fea6dafbf3383dbab1463dbfb3b3d1b94b209";
      #       sha256 = "wmiKxuNjazkOWFcuMvDJzdPp2HhDu8CNL0rxu+8hrKs=";
      #     };
      #   });
      # }
      {
        plugin = suda-vim;
        config = "let g:suda_smart_edit = 1";
      }
      nvim-ts-rainbow
      {
        plugin = nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars);
        type = "lua";
        config = ''
          require"nvim-treesitter.configs".setup {
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
          }
        '';
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''require"colorizer".setup{}'';
      }
      undotree
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      # telescope-termfinder
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require "telescope"
          telescope.load_extension("file_browser")
          telescope.load_extension("projects")
          telescope.load_extension("fzf")
          -- telescope.load_extension("termfinder")
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require"gitsigns".setup()'';
      }
      {
        plugin = project-nvim;
        type = "lua";
        config = ''require"project_nvim".setup()'';
      }
      {
        plugin = lsp_signature-nvim;
        type = "lua";
        config = ''require"lsp_signature".setup{}'';
      }
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local cmp = require "cmp"
          local luasnip = require "luasnip"
          cmp.setup {
            snippet = {
              expand = function (args)
                luasnip.lsp_expand(args.body)
              end
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
              { name = "nvim_lsp" },
              { name = "luasnip" }
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
      set conceallevel=2
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
      nnoremap <cr> :
      vnoremap <cr> :
      set mouse=a     " Enable mouse
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
      set completeopt=menuone,noselect
    '';
  };
}
