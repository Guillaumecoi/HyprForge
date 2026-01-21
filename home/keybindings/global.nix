# Global (WM-level) keybindings for Hyprland
# Window manager level bindings using SUPER key
#
# PHILOSOPHY:
# - SUPER key: Window manager actions - windows, workspaces, launchers
# - SUPER+ALT key: Alternative applications
# - Hardware keys: Brightness, volume, media controls
#
# This file returns Hyprland-compatible keybinding configuration
let
  # Prefer canonical apps defined in ../apps.nix, fallback to environment.nix
  apps = import ../apps.nix;
in
{
  # Main modifier key
  "$mainMod" = "SUPER";

  # App variables
  "$TERMINAL" = apps.terminal;
  "$EDITOR" = apps.editor;
  "$EDITOR_ALT" = apps.editorAlt;
  "$EXPLORER" = apps.explorer;
  "$EXPLORER_ALT" = apps.explorerAlt;
  "$BROWSER" = apps.browser;
  "$BROWSER_ALT" = apps.browserAlt;
  "$NOTES" = apps.notes;

  # Other variables
  "$KBD_BACKLIGHT" = "asus::kbd_backlight"; # Find your keyboard backlight device with `brightnessctl -l`

  # Regular keybindings with descriptions (bindd)
  bindd = [
    "$mainMod, Q, [Window Management|Window Actions] close focused window, killactive"
    "$mainMod, G, [Window Management|Window Actions] toggle group, togglegroup"
    "SHIFT, F11, [Window Management|Window Actions] toggle fullscreen, fullscreen"
    "$mainMod, F, [Window Management|Window Actions] toggle fullscreen, fullscreen"
    "$mainMod SHIFT, F, [Window Management|Window Actions] toggle pin, togglefloating"
    "$mainMod, semicolon, [Window Management|Window Actions] toggle split, togglesplit"
    "$mainMod, G, [Window Management|Window Actions] toggle group, togglegroup"
    "$mainMod, W, [Window Management|Window Actions] toggle waybar, exec, pkill waybar || waybar"

    "$mainMod ALT, H, [Window Management|Group Navigation] change active group backwards, changegroupactive, b"
    "$mainMod ALT, Left, [Window Management|Group Navigation] change active group backwards, changegroupactive, b"
    "$mainMod ALT, L, [Window Management|Group Navigation] change active group forwards, changegroupactive, f"
    "$mainMod ALT, RIGHT, [Window Management|Group Navigation] change active group forwards, changegroupactive, f"

    "$mainMod, Left, [Window Management|Change focus] focus left, movefocus, l"
    "$mainMod, H, [Window Management|Change focus] focus left, movefocus, h"
    "$mainMod, Right, [Window Management|Change focus] focus right, movefocus, r"
    "$mainMod, L, [Window Management|Change focus] focus right, movefocus, l"
    "$mainMod, Up, [Window Management|Change focus] focus up, movefocus, u"
    "$mainMod, K, [Window Management|Change focus] focus up, movefocus, k"
    "$mainMod, Down, [Window Management|Change focus] focus down, movefocus, d"
    "$mainMod, J, [Window Management|Change focus] focus down, movefocus, j"
    "ALT, Tab, [Window Management|Change focus] cycle focus, cyclenext"

    "$mainMod, T, [Launcher|Apps] terminal emulator, exec, $TERMINAL"
    "$mainMod, E, [Launcher|Apps] file explorer (yazi), exec, $EXPLORER"
    "$mainMod ALT, E, [Launcher|Apps] file explorer alt (thunar), exec, $EXPLORER_ALT"
    "$mainMod, C, [Launcher|Apps] text editor (neovim), exec, $TERMINAL -e $EDITOR"
    "$mainMod ALT, C, [Launcher|Apps] text editor alt (code), exec, $EDITOR_ALT"
    "$mainMod, B, [Launcher|Apps] web browser, exec, $BROWSER"
    "$mainMod ALT, B, [Launcher|Apps] web browser alt, exec, $BROWSER_ALT"
    "$mainMod, N, [Launcher|Apps] notes, exec, $NOTES"

    "$mainMod, A, [Launcher|Rofi menus] application finder, exec, pkill -x rofi || rofi -show drun"
    "$mainMod, TAB, [Launcher|Rofi menus] window switcher, exec, pkill -x rofi || rofi -show window"
    "$mainMod SHIFT, E, [Launcher|Rofi menus] file finder, exec, pkill -x rofi || rofi -show filebrowser"
    "$mainMod, comma, [Launcher|Rofi menus] Emoji picker, exec, emoji-picker"
    "$mainMod, period, [Launcher|Rofi menus] Glyph picker, exec, glyph-picker"
    "$mainMod, slash, [Launcher|Rofi menus] Keybind finder, exec, keybinds-hint"
    "$mainMod, F1, [Help|Shortcuts] show all keybindings, exec, keybinds-hint"

    "$mainMod SHIFT, P, [Action|Screen Capture] color picker, exec, hyprpicker -an"
    "$mainMod, P, [Action|Screen Capture] snip section, exec, screenshot-annotate select"
    "$mainMod CTRL, P, [Action|Screen Capture] snip screen, exec, screenshot-annotate full"
    "$mainMod SHIFT, W, [Action|Scripting] change wallpaper, exec, wallpaper-rotate"

    # Session actions
    "CTRL ALT, Delete, [Action|Session] logout menu, exec, wlogout"
    "CTRL ALT, L, [Action|Session] lock screen, exec, hyprlock"

    "$mainMod, 1, [Workspaces|Navigation] navigate to workspace 1, workspace, 1"
    "$mainMod, 2, [Workspaces|Navigation] navigate to workspace 2, workspace, 2"
    "$mainMod, 3, [Workspaces|Navigation] navigate to workspace 3, workspace, 3"
    "$mainMod, 4, [Workspaces|Navigation] navigate to workspace 4, workspace, 4"
    "$mainMod, 5, [Workspaces|Navigation] navigate to workspace 5, workspace, 5"
    "$mainMod, 6, [Workspaces|Navigation] navigate to workspace 6, workspace, 6"
    "$mainMod, 7, [Workspaces|Navigation] navigate to workspace 7, workspace, 7"
    "$mainMod, 8, [Workspaces|Navigation] navigate to workspace 8, workspace, 8"
    "$mainMod, 9, [Workspaces|Navigation] navigate to workspace 9, workspace, 9"
    "$mainMod, 0, [Workspaces|Navigation] navigate to workspace 10, workspace, 10"
    "$mainMod, mouse_down, [Workspaces|Navigation] next workspace, workspace, e+1"
    "$mainMod, mouse_up, [Workspaces|Navigation] previous workspace, workspace, e-1"
    "$mainMod CTRL, Right, [Workspaces|Navigation] change active workspace forwards, workspace, r+1"
    "$mainMod CTRL, L, [Workspaces|Navigation] change active workspace forwards, workspace, r+1"
    "$mainMod CTRL, Left, [Workspaces|Navigation] change active workspace backwards, workspace, r-1"
    "$mainMod CTRL, H, [Workspaces|Navigation] change active workspace backwards, workspace, r-1"
    "$mainMod CTRL, Down, [Workspaces|Navigation] navigate to nearest empty workspace, workspace, empty"
    "$mainMod CTRL, J, [Workspaces|Navigation] navigate to nearest empty workspace, workspace, empty"

    "$mainMod SHIFT, 1, [Workspaces|Move window] move to workspace 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, [Workspaces|Move window] move to workspace 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, [Workspaces|Move window] move to workspace 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, [Workspaces|Move window] move to workspace 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, [Workspaces|Move window] move to workspace 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, [Workspaces|Move window] move to workspace 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, [Workspaces|Move window] move to workspace 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, [Workspaces|Move window] move to workspace 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, [Workspaces|Move window] move to workspace 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, [Workspaces|Move window] move to workspace 10, movetoworkspace, 10"
    "$mainMod CTRL SHIFT, Right, [Workspaces|Move window] move window to next relative workspace, movetoworkspace, r+1"
    "$mainMod CTRL SHIFT, L, [Workspaces|Move window] move window to next relative workspace, movetoworkspace, r+1"
    "$mainMod CTRL SHIFT, Left, [Workspaces|Move window] move window to previous relative workspace, movetoworkspace, r-1"
    "$mainMod CTRL SHIFT, H, [Workspaces|Move window] move window to previous relative workspace, movetoworkspace, r-1"
    "$mainMod CTRL SHIFT, Down, [Workspaces|Move window] move window to nearest empty workspace, movetoworkspace, empty"
    "$mainMod CTRL SHIFT, J, [Workspaces|Move window] move window to nearest empty workspace, movetoworkspace, empty"

    "$mainMod ALT, 1, [Workspaces|Move window silently] move to workspace 1 (silent), movetoworkspacesilent, 1"
    "$mainMod ALT, 2, [Workspaces|Move window silently] move to workspace 2 (silent), movetoworkspacesilent, 2"
    "$mainMod ALT, 3, [Workspaces|Move window silently] move to workspace 3 (silent), movetoworkspacesilent, 3"
    "$mainMod ALT, 4, [Workspaces|Move window silently] move to workspace 4 (silent), movetoworkspacesilent, 4"
    "$mainMod ALT, 5, [Workspaces|Move window silently] move to workspace 5 (silent), movetoworkspacesilent, 5"
    "$mainMod ALT, 6, [Workspaces|Move window silently] move to workspace 6 (silent), movetoworkspacesilent, 6"
    "$mainMod ALT, 7, [Workspaces|Move window silently] move to workspace 7 (silent), movetoworkspacesilent, 7"
    "$mainMod ALT, 8, [Workspaces|Move window silently] move to workspace 8 (silent), movetoworkspacesilent, 8"
    "$mainMod ALT, 9, [Workspaces|Move window silently] move to workspace 9 (silent), movetoworkspacesilent, 9"
    "$mainMod ALT, 0, [Workspaces|Move window silently] move to workspace 10 (silent), movetoworkspacesilent, 10"
    "$mainMod CTRL ALT, Right, [Workspaces|Move window silently] move window to next relative workspace, movetoworkspacesilent, r+1"
    "$mainMod CTRL ALT, L, [Workspaces|Move window silently] move window to next relative workspace, movetoworkspacesilent, r+1"
    "$mainMod CTRL ALT, Left, [Workspaces|Move window silently] move window to previous relative workspace, movetoworkspacesilent, r-1"
    "$mainMod CTRL ALT, H, [Workspaces|Move window silently] move window to previous relative workspace, movetoworkspacesilent, r-1"
    "$mainMod CTRL, Down, [Workspaces|Move window silently] move window to nearest empty workspace, movetoworkspacesilent, empty"
    "$mainMod CTRL, J, [Workspaces|Move window silently] move window to nearest empty workspace, movetoworkspacesilent, empty"

    "$mainMod SHIFT, S, [Workspaces|Special workspace] move to scratchpad, movetoworkspace, special"
    "$mainMod ALT, S, [Workspaces|Special workspace] move to scratchpad (silent), movetoworkspacesilent, special"
    "$mainMod, S, [Workspaces|Special workspace] toggle scratchpad, togglespecialworkspace"
  ];

  # Repeat bindings with descriptions (bindde)
  bindde = [
    "$mainMod SHIFT, Right, [Window Management|Resize Active Window] resize window right, resizeactive, 30 0"
    "$mainMod SHIFT, L, [Window Management|Resize Active Window] resize window right, resizeactive, 30 0"
    "$mainMod SHIFT, Left, [Window Management|Resize Active Window] resize window left, resizeactive, -30 0"
    "$mainMod SHIFT, H, [Window Management|Resize Active Window] resize window left, resizeactive, -30 0"
    "$mainMod SHIFT, Up, [Window Management|Resize Active Window] resize window up, resizeactive, 0 -30"
    "$mainMod SHIFT, K, [Window Management|Resize Active Window] resize window up, resizeactive, 0 -30"
    "$mainMod SHIFT, Down, [Window Management|Resize Active Window] resize window down, resizeactive, 0 30"
    "$mainMod SHIFT, J, [Window Management|Resize Active Window] resize window down, resizeactive, 0 30"
  ];

  binddel = [
    ", XF86MonBrightnessUp, [Hardware Controls|Brightness] increase brightness, exec, brightnessctl set +5%"
    ", XF86MonBrightnessDown, [Hardware Controls|Brightness] decrease brightness, exec, brightnessctl set 5%-"
    "$mainMod, F11, [Hardware Controls|Audio] decrease volume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
    ", XF86AudioLowerVolume, [Hardware Controls|Audio] decrease volume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
    "$mainMod, F12, [Hardware Controls|Audio] increase volume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
    ", XF86AudioRaiseVolume, [Hardware Controls|Audio] increase volume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
  ];

  # Non-repeat bindings with descriptions (binddl)
  binddl = [
    "$mainMod, F10, [Hardware Controls|Audio] toggle mute output, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
    ", XF86AudioMute, [Hardware Controls|Audio] toggle mute output, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
    ", XF86AudioMicMute, [Hardware Controls|Audio] un/mute microphone, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
    ", XF86AudioPlay, [Hardware Controls|Media] play media, exec, playerctl play-pause"
    ", XF86AudioPause, [Hardware Controls|Media] pause media, exec, playerctl play-pause"
    ", XF86AudioNext, [Hardware Controls|Media] next media, exec, playerctl next"
    ", XF86AudioPrev, [Hardware Controls|Media] previous media, exec, playerctl previous"
    ", XF86KbdBrightnessUp, [Hardware Controls|Keyboard Backlight] increase keyboard backlight, exec, brightnessctl -d $KBD_BACKLIGHT set +5%"
    ", XF86KbdBrightnessDown, [Hardware Controls|Keyboard Backlight] decrease keyboard backlight, exec, brightnessctl -d $KBD_BACKLIGHT set 5%-"

    "$mainMod ALT, P, [Launcher|Screen Capture] print monitor, exec, bash -c 'grim ~/Pictures/screenshot-$(date +%s)-monitor.png'"
    ", Print, [Launcher|Screen Capture] print all monitors, exec, bash -c 'grim ~/Pictures/screenshot-$(date +%s)-all.png'"
  ];

  # Mouse bindings with descriptions (binddm)
  binddm = [
    "$mainMod, mouse:272, [Window Management|Move & Resize with mouse] hold to move window, movewindow"
    "$mainMod, mouse:273, [Window Management|Move & Resize with mouse] hold to resize window, resizewindow"
    "$mainMod, Z, [Window Management|Move & Resize with mouse] hold to move window, movewindow"
    "$mainMod, X, [Window Management|Move & Resize with mouse] hold to resize window, resizewindow"
  ];
}
