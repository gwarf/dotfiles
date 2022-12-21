{ config, lib, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraConfig = ''
      (require 'evil)
      ;; Enable evil mode
      (evil-mode 1)
      ;; Set theme
      (load-theme 'nord t)
    '';
    # nix-env -f '<nixpkgs>' -qaP -A emacsPackages
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.magit
      epkgs.nord-theme
      epkgs.auto-complete
      epkgs.whitespace-cleanup-mode
      epkgs.web-mode
      epkgs.smart-tabs-mode
    ];
  };
}
