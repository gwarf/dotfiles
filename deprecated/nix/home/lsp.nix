{ config, pkgs, lib, inputs, ... }:
with inputs.nix2lua.lib;
{
  options = {
    nvimLSP = with lib; with types; let
      packagesType = coercedTo package toList (listOf package);
      configType = nullOr (coercedTo (attrsOf anything) toLua lines);
      packageWithConfigType = coercedTo packagesType (p: { packages = p; }) (submodule ({ config, options, ... }: {
        options = {
          packages = mkOption {
            type = packagesType;
            default = [ ];
          };
          package = mkOption {
            type = nullOr package;
            default = null;
            description = "Alias of `pakcages' for single package";
          };
          config = mkOption {
            type = configType;
            default = null;
            apply = x: if x == null || x == "" then "{}" else x;
          };
        };
        config.packages = mkIf (config.package != null) (mkAliasDefinitions options.package);
      }));
    in
    mkOption {
      type = attrsOf packageWithConfigType;
      default = { };
    };
  };

  config = {
    programs.neovim = with lib; {
      extraPackages = concatMap (getAttr "packages") (attrValues config.nvimLSP);
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = let
            lspConfig = toLua (mapAttrs (name: value: mkLuaRaw
              value.config) config.nvimLSP);
          in
          ''
            local nvim_lsp = require "lspconfig"
            local capabilities = require"cmp_nvim_lsp".default_capabilities(vim.lsp.protocol.make_client_capabilities())
            local on_attach = function (client, bufnr)
              local wk = require "which-key"
              local map = function (from, to, ...)
                return {
                  from, to, ...,
                  buffer = bufnr,
                  noremap = true,
                  silent = true
                }
              end
              wk.register {
               g = {
                 D = map ("<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration"),
                 d = map ("<cmd>lua vim.lsp.buf.definition()<CR>", "Go to defintion"),
                 I = map ("<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation"),
                 r = map ("<cmd>lua vim.lsp.buf.references()<CR>", "References")
               },
               ["<S-k>"] = map ("<cmd>lua vim.lsp.buf.hover()<CR>", "Documentation"),
               ["<C-k>"] = map ("<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help"),
               ["<leader>"] = {
                 w = {
                   name = "Workspace",
                   a = map ("<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder"),
                   r = map ("<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder"),
                   l = map ("<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace folders")
                 },
                 D = map ("<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition"),
                 r = map ("<cmd>lua vim.lsp.buf.rename()<CR>", "Rename"),
                 c = {
                   a = map ("<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action"),
                   f = map ("<cmd>lua vim.lsp.buf.format{async=true}<CR>", "Format buffer")
                 },
                 e = map ("<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics"),
                 q = map ("<cmd>lua vim.diagnostic.set_loclist()<CR>", "Set loclist")
               },
               ["[d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous"),
               ["]d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to next"),
              }
            end
            local servers = ${lspConfig}

            for lsp,cfg in pairs(servers) do
              cfg.on_attach = on_attach
              cfg.capabilities = capabilities
              if lsp == "rust-tools" then
                require"rust-tools".setup { server = cfg }
              else
                nvim_lsp[lsp].setup(cfg)
              end
            end
          '';
        }
      ];
    };
  };
}
