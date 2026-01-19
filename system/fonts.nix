{ pkgs, ... }:

{
  # System-wide font configuration for better rendering
  fonts = {
    enableDefaultPackages = true;

    # Font optimization settings
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight"; # Better for LCD screens
      };
      subpixel = {
        rgba = "rgb"; # For RGB subpixel layout (most common)
        lcdfilter = "default";
      };
      defaultFonts = {
        # Use the patched JetBrains Mono (Nerd Font) as the first monospace
        # entry — the package registers as "JetBrains Mono Nerd Font".
        monospace = [
          "JetBrains Mono Nerd Font"
          "JetBrains Mono"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Inter"
          "DejaVu Sans"
        ];
        serif = [ "DejaVu Serif" ];
      };
    };

    packages = with pkgs; [
      # System UI Fonts
      inter # Modern UI font - better than default sans-serif
      noto-fonts # Google's font family - covers most languages
      noto-fonts-cjk-sans # Chinese, Japanese, Korean support
      noto-fonts-color-emoji # Color emoji support

      source-han-sans # Alternative CJK font
      source-han-serif # Serif CJK font

      # Programming & Terminal Fonts
      nerd-fonts.jetbrains-mono # JetBrains Mono with Nerd Font icons

      # Icon & Theme Support
      papirus-icon-theme # Icon theme (provided by Catppuccin)
      libsForQt5.qtstyleplugin-kvantum # Qt5 theme engine for Catppuccin
      qt6Packages.qtstyleplugin-kvantum # Qt6 theme engine

    ];
  };
}
