## Todo
# - install github cli
# - kitty config
# - neovim config
# - nextcloud
# - i3 config
# - zsh as default shell
# - zsh config
# - firefox: disable password saving
# - access email (mutt, isync, notmuch)
{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.11";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "baptiste";
  # home.homeDirectory = "/home/baptiste";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  home.packages = with pkgs; [
    # Some basics
    curl
    wget
    neovim
    gnupg
    mutt

    # Cool stuff
    fortune
    gh

    # Dev stuff
    jq
    # nodejs

    # Useful graphical tools
    firefox
    kitty

  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    m-cli # useful macOS CLI commands
  ];

  # Misc configuration files --------------------------------------------------------------------{{{

  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  # home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
  #   templates = {
  #     scm-init = "git";
  #     params = {
  #       author-name = "Your Name"; # config.programs.git.userName;
  #       author-email = "youremail@example.com"; # config.programs.git.userEmail;
  #       github-username = "yourusername";
  #     };
  #   };
  #   nix.enable = true;
  # };
}
