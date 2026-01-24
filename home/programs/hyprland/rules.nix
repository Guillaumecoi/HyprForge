{
  # Find the class name with `hyprctl clients | grep class`

  # Window rules using new Hyprland syntax
  # Note: Specific rules should come before general catch-all rules
  windowrule = [
    # Suppress maximize event for all windows
    "suppress_event maximize, match:class .*"

    # Opacity rules - specific rules first
    "opacity 1.0 override 1.0 override, match:class ^(imv)$"
    "opacity 1.0 override 1.0 override, match:class ^(eog)$"
    "opacity 1.0 override 1.0 override, match:class ^(satty)$"
    "opacity 0.95 0.95, match:class ^(firefox)$"
    "opacity 0.80 0.80, match:class ^(kitty)$"
    "opacity 0.90 0.90, match:class .*"

    # Float rules
    "float on, match:class ^(btop)$"
    "float on, match:class ^(org.gnome.SystemMonitor)$"
    "float on, match:class ^(gnome-system-monitor)$"
    "float on, match:class ^(org.pulseaudio.pavucontrol)$"
    "float on, match:class ^(pavucontrol)$"
    "float on, match:class ^(nm-connection-editor)$"
    "float on, match:class ^(blueman-manager)$"
    "float on, match:class ^(nwg-displays)$"
    "float on, match:class ^(nwg-look)$"
    "float on, match:class ^(qt5ct)$"
    "float on, match:class ^(qt6ct)$"
    "float on, match:class ^(kvantummanager)$"
    "float on, match:class ^(org.gnome.Settings)$"
    "float on, match:class ^(gnome-control-center)$"
    "float on, match:class ^(org.gnome.DiskUtility)$"
    "float on, match:class ^(gnome-disks)$"
    "float on, match:class ^(GParted)$"
    "float on, match:class ^(gparted)$"
    "float on, match:class ^(dconf-editor)$"
    "float on, match:class ^(satty)$"
    "float on, match:class ^(imv)$"
    "float on, match:class ^(eog)$"
    "float on, match:class ^(org.gnome.Loupe)$"
    "float on, match:class ^(org.kde.ark)$"
    "float on, match:class ^(signal)$"
    "float on, match:class ^(org.telegram.desktop)$"

    # Picture-in-Picture
    "float on, match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "pin on, match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "size 25% 25%, match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "move 73% 72%, match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "keep_aspect_ratio on, match:title ^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"

    # Workaround for JetBrains IDEs dropdowns/popups flickering
    "no_initial_focus on, match:class ^(.*jetbrains.*)$, match:title ^(win[0-9]+)$"
  ];

  # Layer rules
  # layerrule = [];
}
