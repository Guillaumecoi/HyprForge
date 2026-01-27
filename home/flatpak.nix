{ pkgs, ... }:

# User-specific Flatpak applications
# These are installed per-user, not system-wide
# Use this for personal apps that don't need to be available to all users

{
  services.flatpak = {
    enable = true;

    # User-specific Flatpak packages
    # Add any apps you want installed for your user only
    packages = [
      "com.usebottles.bottles" # Wine GUI manager for Windows apps
      # Example user apps (uncomment as needed):
      # "com.spotify.Client"              # Spotify music
      # "com.discordapp.Discord"          # Discord chat
      # "org.signal.Signal"               # Signal messaging
      # "com.slack.Slack"                 # Slack
      # "org.gimp.GIMP"                   # GIMP image editor
      # "org.inkscape.Inkscape"           # Inkscape vector graphics
      # "com.obsproject.Studio"           # OBS Studio
      # "org.audacityteam.Audacity"       # Audacity audio editor
      # "org.videolan.VLC"                # VLC media player
      # "com.valvesoftware.Steam"         # Steam gaming
    ];
  };
}
