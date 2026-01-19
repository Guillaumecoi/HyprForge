{
  # Find the class name with `hyprctl clients | grep class`

  # Window rules
  windowrule = [
    # Suppress maximize event for all windows
    "suppressevent maximize, class:.*"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

    # Idle inhibit rules
    "idleinhibit fullscreen, class:^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$"
    "idleinhibit fullscreen, class:^(.*[Ss]potify.*)$"
    "idleinhibit fullscreen, class:^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$"

    # Default opacity (0.9 for all windows)
    "opacity 0.90 0.90 1, class:.*"

    # Opacity exceptions
    "opacity 0.95 0.95 1, class:^(firefox)$"
    "opacity 0.80 0.80 1, class:^(kitty)$"
    # Need to set opacity to 1 to have the proper colors
    "opacity 1 1 1, class:^(imv)$"
    "opacity 1 1 1, class:^(eog)$"
    "opacity 1 1 1, class:^(satty)$"

    # Float rules
    # System utilities & monitoring
    "float, class:^(btop)$"
    "float, class:^(org.gnome.SystemMonitor)$"
    "float, class:^(gnome-system-monitor)$"

    # Audio & Network
    "float, class:^(org.pulseaudio.pavucontrol)$"
    "float, class:^(pavucontrol)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(blueman-manager)$"

    # Settings & Configuration
    "float, class:^(nwg-displays)$"
    "float, class:^(nwg-look)$"
    "float, class:^(qt5ct)$"
    "float, class:^(qt6ct)$"
    "float, class:^(kvantummanager)$"
    "float, class:^(org.gnome.Settings)$"
    "float, class:^(gnome-control-center)$"
    "float, class:^(org.gnome.DiskUtility)$"
    "float, class:^(gnome-disks)$"
    "float, class:^(GParted)$"
    "float, class:^(gparted)$"
    "float, class:^(dconf-editor)$"

    # Screenshot & Image tools
    "float, class:^(satty)$"
    "float, class:^(imv)$"
    "float, class:^(eog)$"
    "float, class:^(org.gnome.Loupe)$"

    # Archive manager
    "float, class:^(org.kde.ark)$"

    # Communication apps
    "float, class:^(signal)$"
    "float, class:^(org.telegram.desktop)$"
  ];

  # Window rules v2 (more specific)
  windowrulev2 = [
    # Picture-in-Picture
    "float, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "pin, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "size 25% 25%, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "move 73% 72%, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
    "keepaspectratio, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"

    # Workaround for JetBrains IDEs dropdowns/popups flickering
    "noinitialfocus, class:^(.*jetbrains.*)$, title:^(win[0-9]+)$"
  ];

  # Layer rules
  layerrule = [
    "blur, notifications"
    "blur, swaync-notification-window"
    "blur, swaync-control-center"
    "blur, logout_dialog"
  ];
}
