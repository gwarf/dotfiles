{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    # XXX take this from parameters
    userName = "gwarf";
    userEmail = "baptist@bapt.name";
    extraConfig.core.autoclrf = "input";
    extraConfig.init.defaultBranch = "main";
    extraConfig.status.showUntrackedFiles = "all";
    extraConfig.status.submoduleSummary = true;
    extraConfig.fetch = {
      prune = true;
      pruneTags = true;
    };
    extraConfig.pull = {
      ff = "only";
      rebase = true;
    };
    extraConfig.push = {
      autoSetupRemote = true;
    };
    extraConfig.protocol.version = 2;
    delta = {
      enable = true;
      options = {
        features = "interactive";
        wrap-max-lines = "unlimited";
        max-line-length = 2048;
        syntax-theme = "Dracula";
      };
    };
    lfs.enable = true;
    ignores = [
      ".ccls-cache/"
      ".directory"
      "__pycache__"
      ".pytest_cache"
      ".owncloudsync.log"
      "._sync_*.db*"
      "id_rsa"
      "id_rsa_*"
      "id_dsa"
      "id_dsa_*"
      "id_ed25519"
      "id_ed25519_*"
      "*.key"
      "*.pem"
      "*.pk"
      "*.ppk"
    ];
    attributes = [
      "*.c     diff=cpp"
      "*.h     diff=cpp"
      "*.c++   diff=cpp"
      "*.h++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.hpp   diff=cpp"
      "*.cc    diff=cpp"
      "*.hh    diff=cpp"
      "*.cs    diff=csharp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.ex    diff=elixir"
      "*.exs   diff=elixir"
      "*.go    diff=golang"
      "*.php   diff=php"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rb    diff=ruby"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.lisp  diff=lisp"
      "*.el    diff=lisp"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
      };
      git.paging.pager = "delta --dark --paging=never";
    };
  };
}

