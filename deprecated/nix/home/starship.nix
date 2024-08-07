{
  # Starship Prompt
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
  programs.starship.enable = true;
  # Transient prompt
  # XXX: not recognised?
  # programs.starship.enableTransience = true;
  # Disable support for other shells
  programs.starship.enableZshIntegration = false;
  programs.starship.enableNushellIntegration = false;

  programs.starship.settings = {
    # See docs here: https://starship.rs/config/
    # Symbols config configured ./starship-symbols.nix.

    # cmd_duration.min_time = "2_000";
    cmd_duration.format = " ⏲ $duration($style) ";
    cmd_duration.style = "bold italic #87A752";
    # turn on fish directory truncation
    directory.fish_style_pwd_dir_length = 1;
    # number of directories not to truncate
    directory.truncation_length = 2;
    # annoying to always have on
    gcloud.disabled = true;
    # hostname.style = "bold green";
    # because it includes cached memory it's reported as full a lot
    memory_usage.disabled = true;
    # Wait 10 milliseconds for starship to check files under the current directory.
    scan_timeout = 10;
    shlvl.disabled = false;
    username.style_user = "bold blue"; # don't like the default
  };
}
