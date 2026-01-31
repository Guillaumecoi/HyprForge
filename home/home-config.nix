{
  # User-specific configuration for Home Manager
  # This file contains personal settings that vary between users

  # Git configuration
  git = {
    fullName = "Your Name";
    email = "your.email@example.com";
  };

  # Monitor configuration for Hyprland
  # Format: "name,resolution,position,scale"
  # Examples:
  #   ",preferred,auto,1" - Auto-detect single monitor
  #   "DP-1,1920x1080@60,0x0,1" - Specific monitor configuration
  #   ["DP-1,1920x1080,0x0,1" "DP-2,1920x1080,1920x0,1"] - Dual monitor
  monitors = [
    ",preferred,auto,1"
  ];

  # Theme preferences
  theme = {
    flavor = "mocha"; # mocha (dark), macchiato, frappe, latte (light)
    accent = "mauve"; # blue, flamingo, green, lavender, maroon, mauve, peach, pink, red, rosewater, sapphire, sky, teal, yellow
  };

  # Cursor settings
  cursor = {
    theme = "Bibata-Modern-Classic";
    size = 24;
  };

  # Font preferences
  fonts = {
    terminal = {
      family = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  # Power/idle timeouts (seconds)
  timeouts = {
    dim = 240;
    lock = 300;
    screenOff = 420;
    suspend = 3600;
  };
}
