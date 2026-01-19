{
  config,
  pkgs,
  lib,
  ...
}:

# Note: Shortcuts are hardcoded in Firefox and cannot be changed via NixOS configuration

let
  # Fetch Catppuccin Mocha theme from Firefox Add-ons
  catppuccin-mocha = pkgs.fetchFirefoxAddon {
    name = "catppuccin-mocha-mauve";
    url = "https://addons.mozilla.org/firefox/downloads/file/3954870/catppuccin_mocha_mauve-2.0.xpi";
    sha256 = "05jfpckpvfkd1r24i96k7smcl67kpxib2ibwpvfdv9qqbha68c0l";
  };
in
{
  programs.firefox = {
    # Firefox policies (enterprise settings)
    policies = {
      # Disable telemetry
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      # Disable pockent
      DisablePocket = true;

      # Don't check if Firefox is default browser
      DontCheckDefaultBrowser = true;

      # Enable user chrome customization
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };

      # Homepage settings
      Homepage = {
        StartPage = "previous-session";
      };

      # Enable hardware acceleration
      HardwareAcceleration = true;
    };

    # Firefox profiles
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";

      # User preferences
      settings = {
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.donottrackheader.enabled" = true;

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "browser.ping-centre.telemetry" = false;

        # Appearance
        "browser.uidensity" = 1; # Compact mode
        "browser.theme.content-theme" = 0; # Dark
        "browser.theme.toolbar-theme" = 0; # Dark
        "ui.systemUsesDarkTheme" = 1;

        # Catppuccin colors (Mocha variant) - can be customized in about:config
        "browser.theme.dark-private-windows" = true;

        # Performance
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true; # Hardware video decode

        # Tab behavior
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnCloseOtherTabs" = false;

        # New tab page
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Search
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = true;

        # Downloads
        "browser.download.useDownloadDir" = true;
        "browser.download.dir" = "$HOME/Downloads";
        "browser.download.folderList" = 2; # Use custom download dir

        # Smooth scrolling
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;

        # Font rendering
        "gfx.text.subpixel-position.force-enabled" = true;

        # Disable annoyances
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.messaging-system.whatsNewPanel.enabled" = false;

        # Restore previous session
        "browser.startup.page" = 3;

        # Accessibility
        "accessibility.typeaheadfind.flashBar" = 0;

        # Custom keybindings - Native Firefox shortcuts
        "browser.tabs.selectOwnerOnClose" = false;
      };

      # Browser extensions
      extensions = {
        packages =
          (with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin # Ad blocker
            sponsorblock # Skip YouTube sponsors/promotions
            vimium # Vim-style navigation
            bitwarden # Password manager
            darkreader # Dark mode for websites
          ])
          ++ [
            catppuccin-mocha # Catppuccin Mocha theme
          ];

        # Acknowledge that settings will override previous extensions settings
        force = true;
      };
    };
  };
}

