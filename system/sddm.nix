# sddm.nix - SDDM Display Manager Configuration with Catppuccin Theme
{ config
, pkgs
, lib
, ...
}:

let
  # Create two separate Hyprland sessions
  # 1. Direct Hyprland session (no Home Manager)
  hyprland-session = (pkgs.writeTextDir "share/wayland-sessions/hyprland-direct.desktop" ''
    [Desktop Entry]
    Name=Hyprland (Direct)
    Comment=Hyprland without Home Manager
    Exec=Hyprland
    Type=Application
    DesktopNames=Hyprland-Direct
    Keywords=tiling;wayland;compositor;
  '').overrideAttrs (_: { passthru.providedSessions = [ "hyprland-direct" ]; });

  # 2. Home Manager Hyprland session
  hyprland-hm-session = (pkgs.writeTextDir "share/wayland-sessions/hyprland-hm.desktop" ''
    [Desktop Entry]
    Name=Hyprland (Home Manager)
    Comment=Hyprland with Home Manager configuration
    Exec=start-hyprland
    Type=Application
    DesktopNames=Hyprland-HomeManager
    Keywords=tiling;wayland;compositor;
  '').overrideAttrs (_: { passthru.providedSessions = [ "hyprland-hm" ]; });
in
{
  # SDDM Display Manager Configuration
  services.displayManager.sddm = {
    enable = true;

    # Enable Wayland support
    wayland = {
      enable = true;
      compositor = "kwin"; # Can also use weston if kwin doesn't work
    };

    # Theme configuration
    theme = "catppuccin-mocha";

    # Use KDE6 version for better Wayland support
    package = pkgs.kdePackages.sddm;

    settings = {
      # General settings
      General = {
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        InputMethod = ""; # Can be set to "qtvirtualkeyboard" if needed
      };

      # Input configuration for mouse/touchpad
      Input = {
        EnableMouse = true;
        EnableTouchpad = true;
        EnableTapToClick = true;
      };

      # Theme settings
      Theme = {
        Current = "catppuccin-mocha-mauve";
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
        FacesDir = "/var/lib/AccountsService/icons";
        # Use a Bibata variant provided by the `bibata-cursors` package
        # (installed in `systemPackages`). Pick a Modern Classic variant.
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 24;
        Font = "JetBrainsMono Nerd Font";
        EnableAvatars = true;
        DisableAvatarsThreshold = 7;
      };

      # Wayland specific settings
      Wayland = {
        CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --no-lockscreen";
        EnableHiDPI = true;
      };

      # Autologin (disabled by default, uncomment to enable)
      # Autologin = {
      #   User = "changeme"; # Replace with your username
      #   Session = "hyprland";
      # };

      # User settings
      Users = {
        DefaultPath = "/run/current-system/sw/bin";
        HideShells = "";
        HideUsers = "";
        MaximumUid = 60513;
        MinimumUid = 1000;
        RememberLastSession = true;
        RememberLastUser = true;
        ReuseSession = false;
      };
    };
  };

  # Ensure SDDM theme and dependencies are installed
  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      fontSize = "9";
      background = "${../share/wallpapers/sakura-gate.jpg}";
      loginBackground = true;
    })
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qtquick3d
    kdePackages.qtvirtualkeyboard
  ];

  # Register custom Hyprland sessions with the display manager
  services.displayManager.sessionPackages = [
    hyprland-session
    hyprland-hm-session
  ];

  # Create SDDM configuration directory
  systemd.tmpfiles.rules = [
    "d /var/lib/sddm 0755 sddm sddm"
    "d /var/lib/sddm/.config 0755 sddm sddm"
    "d /var/lib/sddm/.config/hypr 0755 sddm sddm"
    "d /var/lib/sddm/.icons 0755 sddm sddm"
    "d /var/lib/sddm/.icons/default 0755 sddm sddm"
  ];

  # Create a basic Hyprland config for SDDM
      environment.etc."sddm/hyprland.conf" = {
    text = ''
      # Basic Hyprland configuration for SDDM
      monitor=,preferred,auto,1

      # Use integrated GPU for SDDM to save power
      env = WLR_DRM_DEVICES=/dev/dri/card0

      # Enable mouse/touchpad input
      input {
        follow_mouse = 1
        touchpad {
          natural_scroll = true
        }
      }

      # Basic appearance with Catppuccin Mocha colors
      general {
        border_size = 2
        gaps_in = 5
        gaps_out = 10
        col.active_border = rgba(cba6f7ff)    # Catppuccin Mocha mauve
        col.inactive_border = rgba(313244ff)  # Catppuccin Mocha surface0
      }

      decoration {
        rounding = 10
        blur {
          enabled = true
          size = 3
          passes = 1
        }
      }

      # Basic animations
      animations {
        enabled = yes
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 3, myBezier
        animation = windowsOut, 1, 3, default, popin 80%
        animation = fade, 1, 3, default
      }
    '';
  };

  # Link the config to SDDM's home directory and set up cursor theme
  system.activationScripts.sddmConfig = ''
    if [ ! -f /var/lib/sddm/.config/hypr/hyprland.conf ]; then
      ln -sf /etc/sddm/hyprland.conf /var/lib/sddm/.config/hypr/hyprland.conf 2>/dev/null || true
    fi

    # Set up cursor theme for SDDM
    cat > /var/lib/sddm/.icons/default/index.theme << EOF
[Icon Theme]
Inherits=Bibata-Modern-Classic
EOF
    chown -R sddm:sddm /var/lib/sddm/.icons
  '';
}
