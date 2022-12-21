{ config, lib, pkgs, ... }:
{
  services.emacs.enable = false;
  programs.emacs = {
    enable = true;
    extraConfig = ''
      ;;(require 'evil)
      ;; Enable evil mode
      ;;(evil-mode 1)
      ;; Set theme
      (load-theme 'nord t)
      ;; Enable dashboard
      (require 'dashboard)
      (dashboard-setup-startup-hook)
      (when (display-graphic-p)
        (require 'all-the-icons))
      (require 'doom-modeline)
        (doom-modeline-mode 1)
      (set-face-attribute 'default nil :height 150)
    '';
    # nix-env -f '<nixpkgs>' -qaP -A emacsPackages
    extraPackages = epkgs: [
      # epkgs.evil
      epkgs.magit
      epkgs.nord-theme
      epkgs.auto-complete
      epkgs.whitespace-cleanup-mode
      epkgs.web-mode
      epkgs.nix-mode
      epkgs.json-mode
      epkgs.python-mode
      epkgs.flycheck
      epkgs.flycheck-pyflakes
      epkgs.smart-tabs-mode
      epkgs.dashboard
      epkgs.all-the-icons
      epkgs.projectile
      epkgs.page-break-lines
      epkgs.doom-modeline
      epkgs.doom-themes
    ];
  };
}
