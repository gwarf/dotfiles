{ config, lib, pkgs, ... }:

let
  inherit (lib) elem optionalString;
  inherit (config.home.user-info) nixConfigDirectory;
in

{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  programs.fish.enable = true;

  # Add Fish plugins
  home.packages = [ pkgs.fishPlugins.done pkgs.sqlite ];

  # Fish configuration ------------------------------------------------------------------------- {{{

  # Aliases
  programs.fish.shellAliases = {
    # Nix related
    drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    flakeup = "nix flake update ${nixConfigDirectory}";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix search";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${pkgs.bat}/bin/bat --paging=never";
    more = "${pkgs.bat}/bin/bat";
    less = "${pkgs.bat}/bin/bat";
    du = "${pkgs.du-dust}/bin/dust";
    g = "${pkgs.git}/bin/git";
    ls = "${pkgs.exa}/bin/exa";
    lsd = "${pkgs.exa}/bin/exa -D";
    ll = "ls -l --time-style long-iso --icons";
    la = "ll -a";
    l = "ls -l --time-style long-iso --icons";
    df = "${pkgs.pydf}/bin/pydf";

    # Be conservative with files
    # --preserver-root is for GNU versions
    # do not delete / or prompt if deleting more than 3 files at a time
    rm = "rm -i --preserve-root";
    mv = "mv -i";
    cp = "cp -i";
    # Preventing changing perms on /
    chown = "chown --preserve-root";
    chmod = "chmod --preserve-root";
    chgrp = "chgrp --preserve-root";
  };

  # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
  programs.fish.shellInit = ''
    set -U fish_term24bit 1
  '';

  programs.fish.interactiveShellInit = ''
    set -g fish_greeting ""
    ${pkgs.thefuck}/bin/thefuck --alias | source

    # Use bat as pager
    set -Ux PAGER "${pkgs.bat}/bin/bat"
    # https://unix.stackexchange.com/questions/343168/can-i-prevent-service-foo-status-from-paging-its-output-through-less
    set -Ux SYSTEMD_PAGER "${pkgs.bat}/bin/bat"
    set -Ux MANPAGER "nvim +Man!"

    # Need clang from homebrew on macOS (for C++11 / 14 with neorg and tree-sitter)
    if test (uname) = Darwin
      # Add nix directories to path missing in current kitty config 
      fish_add_path "~/.nix-profile/bin"
      fish_add_path "/etc/profiles/per-user/$USER/bin"
      fish_add_path "/run/current-system/sw/bin"
      fish_add_path "/nix/var/nix/profiles/default/bin"

      # Add path mainly used by brew
      fish_add_path "/usr/local/bin"

      # https://github.com/pyenv/pyenv/wiki/Common-build-problems
      # XXX clang-15: unknown argument -02
      # set -Ux CFLAGS "-02 -I/usr/local/opt/openssl/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
      set -Ux CFLAGS "-I/usr/local/opt/openssl/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"

      # Favor using llvm stuff from homebrew
      set -Ux CPPFLAGS "-I/usr/local/opt/llvm/include"
      set -Ux LDFLAGS "-L/usr/local/opt/openssl/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"
      fish_add_path "/usr/local/opt/llvm/bin"

      # Use clang/llvm as main compiler
      set -Ux CC clang
      set -Ux CXX clang++

      # Load pyenv
      set -x PYENV_ROOT $HOME/.pyenv
      fish_add_path $PYENV_ROOT/bin
      pyenv init - | source
    end

    # nvim!
    set EDITOR nvim
    fish_vi_key_bindings

    # Set color variables
    set emphasized_text  brcyan   # base1
    set normal_text      brblue   # base0
    set secondary_text   brgreen  # base01
    set background_light black    # base02
    set background       brblack  # base03
    set -g fish_color_quote        cyan      # color of commands
    set -g fish_color_redirection  brmagenta # color of IO redirections
    set -g fish_color_end          blue      # color of process separators like ';' and '&'
    set -g fish_color_error        red       # color of potential errors
    set -g fish_color_match        --reverse # color of highlighted matching parenthesis
    set -g fish_color_search_match --background=yellow
    set -g fish_color_selection    --reverse # color of selected text (vi mode)
    set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
    set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
    set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command
    set -g fish_color_command                    $emphasized_text --bold  # color of commands
    set -g fish_color_param                      $normal_text             # color of regular command parameters
    set -g fish_color_comment                    $secondary_text          # color of comments
    set -g fish_color_autosuggestion             $secondary_text          # color of autosuggestions
    set -g fish_pager_color_prefix               $emphasized_text --bold  # color of the pager prefix string
    set -g fish_pager_color_description          $selection_text          # color of the completion description
    set -g fish_pager_color_selected_prefix      $background
    set -g fish_pager_color_selected_completion  $background
    set -g fish_pager_color_selected_description $background

    # Set LS_COLORS
    set -xg LS_COLORS (${pkgs.vivid}/bin/vivid generate dracula)

    [ -e $HOME/fish.env ]; and source $HOME/fish.env
  '';
  # }}}
}
# vim: foldmethod=marker
