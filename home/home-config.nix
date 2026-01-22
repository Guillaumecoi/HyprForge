{
  # User-specific configuration for Home Manager
  # This file contains personal settings that vary between users

  # Git configuration
  git = {
    fullName = "GuillaumeCoi";
    email = "GuillaumeCoi@users.noreply.github.com";
  };

  # Monitor configuration for Hyprland
  # Format: "name,resolution,position,scale"
  # Examples:
  #   ",preferred,auto,1" - Auto-detect single monitor
  #   "DP-1,1920x1080@60,0x0,1" - Specific monitor configuration
  #   "DP-1,1920x1080,0x0,1,DP-2,1920x1080,1920x0,1" - Dual monitor
  monitors = [
    ",preferred,auto,1.2"
  ];
}
