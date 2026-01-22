# Kitty terminal emulator configuration
# Keybindings are dynamically imported from central keybindings.nix
#
# Tab management handled by kitty using central keybindings
# AI Integration: Ctrl+Alt+I opens AI CLI

{ config
, pkgs
, lib
, ...
}:

let
  # Import central keybindings with lib for converter functions
  central = import ../../keybindings { inherit lib; };
  keys = central.kitty; # Pre-converted for kitty format
  aiCli = central.apps.aiCli;
in
{
  programs.kitty = {
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      confirm_os_window_close = 0;

      # Enable kitty tab bar for native tab management
      tab_bar_style = "powerline";
      tab_bar_edge = "top";
      tab_bar_align = "left";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}: {title}";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";

      # Window settings
      window_padding_width = 4;
      hide_window_decorations = "yes";
      background_opacity = "0.95";

      # Scrollback - keep some for when not in tmux
      scrollback_lines = 10000;

      # URL handling
      url_style = "curly";
      open_url_with = central.apps.browser;
    };

    # Keybindings dynamically from central config
    keybindings = {
      # Tab management from central keybindings
      "${keys.tabs.new}" = "new_tab";
      "${keys.tabs.close}" = "close_tab";
      "${keys.tabs.next}" = "next_tab";
      "${keys.tabs.prev}" = "previous_tab";
      "${keys.tabs.goto1}" = "goto_tab 1";
      "${keys.tabs.goto2}" = "goto_tab 2";
      "${keys.tabs.goto3}" = "goto_tab 3";
      "${keys.tabs.goto4}" = "goto_tab 4";
      "${keys.tabs.goto5}" = "goto_tab 5";
      "${keys.tabs.goto6}" = "goto_tab 6";
      "${keys.tabs.goto7}" = "goto_tab 7";
      "${keys.tabs.goto8}" = "goto_tab 8";
      "${keys.tabs.goto9}" = "goto_tab 9";
      "${keys.tabs.gotoLast}" = "goto_tab -1";

      # Font size / zoom
      "${keys.view.zoomIn}" = "change_font_size all +1.0";
      "${keys.view.zoomInAlt}" = "change_font_size all +1.0";
      "${keys.view.zoomOut}" = "change_font_size all -1.0";
      "${keys.view.zoomReset}" = "change_font_size all 0";

      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      # Reload kitty config
      "ctrl+shift+f5" = "load_config_file";

      # New kitty OS window
      "ctrl+shift+n" = "new_os_window";

      # Close kitty OS window
      "ctrl+shift+w" = "close_os_window";
    };
  };

  # Enable Catppuccin theming
  catppuccin.kitty.enable = true;
}
