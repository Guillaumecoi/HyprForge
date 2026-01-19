{
  # Monitor configuration
  monitor = ",1920x1080,auto,1";

  # Hyprland-specific environment variables
  # Note: Theme env vars are also set in home/environment.nix for non-Hyprland apps
  # These are set here to ensure they're available in the Hyprland session
  env = [
  ];

  exec-once = [
    "waybar"
    "swww init" # Initialize swww daemon
    "wallpaper-rotate" # Set random wallpaper at startup
    "wl-paste --type text --watch cliphist store" # Start clipboard history daemon
    "wl-paste --type image --watch cliphist store" # Store image clipboard items
    "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'" # Set GTK dark theme
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'" # Set color scheme preference
  ];

  # General appearance and behavior
  general = {
    gaps_in = 1;
    gaps_out = 2;
    border_size = 2;
    "col.active_border" = "rgba(74c7ecee) rgba(74c7ecee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = false;
    allow_tearing = false;
    layout = "dwindle";
  };

  # Decoration settings
  decoration = {
    rounding = 10;
    active_opacity = 1.0;
    inactive_opacity = 1.0;

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = true;
      size = 3;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  # Layout settings
  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_status = "master";
  };

  # Miscellaneous settings
  misc = {
    force_default_wallpaper = -1;
    disable_hyprland_logo = false;
  };
}
