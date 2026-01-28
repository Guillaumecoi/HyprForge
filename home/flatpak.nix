{ config, pkgs, ... }:

# User-level Flatpak configuration
# Flatpak service is enabled system-wide in system/services.nix
# Packages are installed at user level for better isolation

let
  # List of Flatpak packages to install for this user
  flatpakPackages = [
    # "com.usebottles.bottles"         # Wine GUI for Windows apps (Fusion 360)

    # Add your personal apps here (uncomment as needed):
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

  # Generate installation script
  installScript = pkgs.writeShellScript "install-user-flatpaks.sh" ''
    #!/usr/bin/env bash
    set -e

    # Use full path to flatpak from Nix store
    FLATPAK="${pkgs.flatpak}/bin/flatpak"

    echo "📦 Installing user Flatpak packages..."

    # Add Flathub remote if not already added
    if ! $FLATPAK remote-list --user 2>/dev/null | grep -q flathub; then
      echo "Adding Flathub remote..."
      $FLATPAK remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    # Install each package
    ${pkgs.lib.concatMapStringsSep "\n" (pkg: ''
      if ! $FLATPAK list --user 2>/dev/null | grep -q "${pkg}"; then
        echo "Installing ${pkg}..."
        $FLATPAK install --user -y flathub ${pkg} || echo "⚠️  Failed to install ${pkg}"
      else
        echo "✓ ${pkg} already installed"
      fi
    '') flatpakPackages}

    echo "✅ Flatpak installation complete!"
  '';
in
{
  # Create activation script to install Flatpaks on home-manager switch
  home.activation.installFlatpaks = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${installScript}
  '';

  # Also create a manual script users can run
  home.file.".local/bin/install-user-flatpaks".source = installScript;
  home.file.".local/bin/install-user-flatpaks".executable = true;
}
