# https://github.com/mozilla/policy-templates/blob/master/README.md
# https://github.com/DPDmancul/dotfiles/blob/928d666ba20926451dacd4e251b95a6329fd2e68/src/modules/home/firefox.md

{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings =
          let
            ext = name: {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
            };
          in
          {
            # Prevent manual installation of extensions
            # "*" = {
            #   installation_mode = "blocked";
            #   blocked_install_message = "Extensions managed by home-manager.";
            # };
            "uBlock0@raymondhill.net" = ext "ublock-origin";
            "@contain-facebook" = ext "facebook-container";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
            # Cookie quick manager
            "{60f82f00-9ad5-4de5-b31c-b16a47c51558}" = ext "cookie-quick-manager";
            # cookies.txt: for exporting cookies to a Netscape HTTP Cookie file
            # "{12cf650b-1822-40aa-bff0-996df6948878}" = ext "cookies.txt";
            # foxyproxy Standard
            "foxyproxy@eric.h.jung" = ext "foxyproxy";
            # wappalyzer
            "wappalyzer@crunchlabz.com" = ext "wappalyzer";
            # https://addons.mozilla.org/firefox/downloads/file/4066782/foxytab-2.31.xpi
            # = ext "foxytab";
            # Gnome shell integration
            # "chrome-gnome-shell@gnome.org" = ext "gnome-shell-integration";
            "dictionnaire_francais1" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/3581786/dictionnaire_francais1-latest.xpi";
            };
          };
        PasswordManagerEnabled = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
      };
    };
    profiles.default = {
      settings = {
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.useDownloadDir" = false;
        "browser.download.dir" = "${config.xdg.userDirs.download}/Firefox";
        "media.ffmpeg.vaapi.enabled" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.search.suggest.enabled" = true;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
      };
    };
  };
}
