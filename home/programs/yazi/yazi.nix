# Yazi file manager configuration
# Keybindings are dynamically imported from central keybindings.nix
# Note: Yazi is a TUI file manager with vim-like defaults
#
# AI Integration: Ctrl+Alt+I opens the AI CLI in current directory

{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Import central keybindings with lib for converter functions
  central = import ../../keybindings { inherit lib; };
  keys = central.yazi; # Pre-converted for yazi format (<C-t>, <A-1>, etc.)

  # AI CLI command - opens in current directory
  aiCli = central.apps.aiCli;
in
{
  programs.yazi = {
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };
      preview = {
        max_width = 600;
        max_height = 900;
        image_filter = "triangle";
        image_quality = 75;
      };
      opener = {
        edit = [
          {
            run = "${central.apps.editor} \"$@\"";
            block = true;
            desc = "Edit in editor";
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"";
            desc = "Open with default";
          }
        ];
      };
    };

    # Keybindings dynamically from central config
    keymap = {
      manager.keymap = [
        # Quit/close
        {
          on = [ "q" ];
          run = "quit";
          desc = "Quit yazi";
        }
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Cancel/escape";
        }

        # Navigation - vim style
        {
          on = [ "h" ];
          run = "leave";
          desc = "Go to parent directory";
        }
        {
          on = [ "j" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "k" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "l" ];
          run = "enter";
          desc = "Enter directory/open file";
        }

        # Arrow key navigation
        {
          on = [ "<Left>" ];
          run = "leave";
          desc = "Go to parent directory";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "<Right>" ];
          run = "enter";
          desc = "Enter directory/open file";
        }

        # Page navigation
        {
          on = [ "<C-u>" ];
          run = "arrow -50%";
          desc = "Page up";
        }
        {
          on = [ "<C-d>" ];
          run = "arrow 50%";
          desc = "Page down";
        }
        {
          on = [ "<PageUp>" ];
          run = "arrow -50%";
          desc = "Page up";
        }
        {
          on = [ "<PageDown>" ];
          run = "arrow 50%";
          desc = "Page down";
        }

        # Go to top/bottom
        {
          on = [
            "g"
            "g"
          ];
          run = "arrow -99999999";
          desc = "Go to top";
        }
        {
          on = [ "G" ];
          run = "arrow 99999999";
          desc = "Go to bottom";
        }
        {
          on = [ "<Home>" ];
          run = "arrow -99999999";
          desc = "Go to top";
        }
        {
          on = [ "<End>" ];
          run = "arrow 99999999";
          desc = "Go to bottom";
        }

        # Tab management - simple number keys for yazi
        {
          on = [ "t" ];
          run = "tab_create";
          desc = "New tab";
        }
        {
          on = [ keys.windows.terminal ];
          run = "shell 'kitty --working-directory \"$PWD\" &' --confirm";
          desc = "Open terminal here (ctrl+t)";
        }
        {
          on = [ keys.tabs.close ];
          run = "tab_close 0";
          desc = "Close tab (ctrl+w)";
        }
        {
          on = [ "<Tab>" ];
          run = "tab_switch 1 --relative";
          desc = "Next tab";
        }
        {
          on = [ "<S-Tab>" ];
          run = "tab_switch -1 --relative";
          desc = "Previous tab";
        }

        # Tab navigation by number - simple keys for yazi
        {
          on = [ "1" ];
          run = "tab_switch 0";
          desc = "Go to tab 1";
        }
        {
          on = [ "2" ];
          run = "tab_switch 1";
          desc = "Go to tab 2";
        }
        {
          on = [ "3" ];
          run = "tab_switch 2";
          desc = "Go to tab 3";
        }
        {
          on = [ "4" ];
          run = "tab_switch 3";
          desc = "Go to tab 4";
        }
        {
          on = [ "5" ];
          run = "tab_switch 4";
          desc = "Go to tab 5";
        }
        {
          on = [ "6" ];
          run = "tab_switch 5";
          desc = "Go to tab 6";
        }
        {
          on = [ "7" ];
          run = "tab_switch 6";
          desc = "Go to tab 7";
        }
        {
          on = [ "8" ];
          run = "tab_switch 7";
          desc = "Go to tab 8";
        }
        {
          on = [ "9" ];
          run = "tab_switch 8";
          desc = "Go to tab 9";
        }

        # Search/filter (from central keybindings)
        {
          on = [ "/" ];
          run = "search fd";
          desc = "Search files";
        }
        {
          on = [ keys.navigation.find ];
          run = "search fd";
          desc = "Search files";
        }
        {
          on = [ "?" ];
          run = "search rg";
          desc = "Search content";
        }
        {
          on = [ "n" ];
          run = "search_next";
          desc = "Next search result";
        }
        {
          on = [ "N" ];
          run = "search_prev";
          desc = "Previous search result";
        }

        # File operations
        {
          on = [ "<Enter>" ];
          run = "open";
          desc = "Open file";
        }
        {
          on = [ "o" ];
          run = "open";
          desc = "Open file";
        }
        {
          on = [ "O" ];
          run = "open --interactive";
          desc = "Open with...";
        }
        {
          on = [ "e" ];
          run = "open";
          desc = "Edit file";
        }

        # Selection (from central keybindings)
        {
          on = [ "<Space>" ];
          run = "select --state=none";
          desc = "Toggle selection";
        }
        {
          on = [ "v" ];
          run = "visual_mode";
          desc = "Visual mode";
        }
        {
          on = [ "V" ];
          run = "visual_mode --unset";
          desc = "Exit visual mode";
        }
        {
          on = [ "<C-a>" ];
          run = "select_all --state=true";
          desc = "Select all";
        }

        # Copy/cut/paste (vim style for TUI)
        {
          on = [ "y" ];
          run = "yank";
          desc = "Yank (copy)";
        }
        {
          on = [ "x" ];
          run = "yank --cut";
          desc = "Cut";
        }
        {
          on = [ "p" ];
          run = "paste";
          desc = "Paste";
        }
        {
          on = [ "P" ];
          run = "paste --force";
          desc = "Paste (overwrite)";
        }

        # Delete
        {
          on = [ "d" ];
          run = "remove";
          desc = "Delete (to trash)";
        }
        {
          on = [ "D" ];
          run = "remove --permanently";
          desc = "Delete permanently";
        }
        {
          on = [ "<Delete>" ];
          run = "remove";
          desc = "Delete (to trash)";
        }

        # Create/rename
        {
          on = [ "a" ];
          run = "create";
          desc = "Create file/directory";
        }
        {
          on = [ "r" ];
          run = "rename --cursor=before_ext";
          desc = "Rename";
        }

        # Hidden files toggle
        {
          on = [ "." ];
          run = "hidden toggle";
          desc = "Toggle hidden files";
        }

        # AI Integration - open AI CLI in current directory
        {
          on = [ keys.ai.chat ];
          run = ''shell 'cd "$PWD" && "${aiCli}"' --block --confirm'';
          desc = "Open AI assistant";
        }

        # Sorting
        {
          on = [
            ","
            "m"
          ];
          run = "sort modified --reverse";
          desc = "Sort by modified";
        }
        {
          on = [
            ","
            "n"
          ];
          run = "sort natural";
          desc = "Sort by name";
        }
        {
          on = [
            ","
            "s"
          ];
          run = "sort size --reverse";
          desc = "Sort by size";
        }
        {
          on = [
            ","
            "e"
          ];
          run = "sort extension";
          desc = "Sort by extension";
        }

        # Go to specific locations
        {
          on = [
            "g"
            "h"
          ];
          run = "cd ~";
          desc = "Go to home";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "Go to config";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/Downloads";
          desc = "Go to downloads";
        }
        {
          on = [
            "g"
            "D"
          ];
          run = "cd ~/Documents";
          desc = "Go to documents";
        }
        {
          on = [
            "g"
            "p"
          ];
          run = "cd ~/Projects";
          desc = "Go to projects";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/HyprForge";
          desc = "Go to dotfiles";
        }
        {
          on = [
            "g"
            "/"
          ];
          run = "cd /";
          desc = "Go to root";
        }

        # Shell
        {
          on = [ ":" ];
          run = "shell --interactive";
          desc = "Run shell command";
        }
        {
          on = [ "!" ];
          run = "shell --block --interactive";
          desc = "Run blocking shell command";
        }

        # Help
        {
          on = [ "~" ];
          run = "help";
          desc = "Show help";
        }
        {
          on = [ keys.help.shortcuts ];
          run = "help";
          desc = "Show help (universal shortcut)";
        }
        {
          on = [ "<F1>" ];
          run = "help";
          desc = "Show help (legacy F1)";
        }

        # Refresh
        {
          on = [ "<C-r>" ];
          run = "refresh";
          desc = "Refresh";
        }
        {
          on = [ "<F5>" ];
          run = "refresh";
          desc = "Refresh";
        }
      ];

      # Tasks view keybindings
      tasks.keymap = [
        {
          on = [ "q" ];
          run = "close";
          desc = "Close tasks";
        }
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Close tasks";
        }
        {
          on = [ "j" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "k" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "<Enter>" ];
          run = "inspect";
          desc = "Inspect task";
        }
        {
          on = [ "x" ];
          run = "cancel";
          desc = "Cancel task";
        }
      ];

      # Input dialog keybindings
      input.keymap = [
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Cancel";
        }
        {
          on = [ "<Enter>" ];
          run = "close --submit";
          desc = "Submit";
        }
        {
          on = [ "<C-c>" ];
          run = "close";
          desc = "Cancel";
        }

        # Movement
        {
          on = [ "<Left>" ];
          run = "move -1";
          desc = "Move left";
        }
        {
          on = [ "<Right>" ];
          run = "move 1";
          desc = "Move right";
        }
        {
          on = [ "<Home>" ];
          run = "move -999";
          desc = "Go to start";
        }
        {
          on = [ "<End>" ];
          run = "move 999";
          desc = "Go to end";
        }
        {
          on = [ "<C-a>" ];
          run = "move -999";
          desc = "Go to start";
        }
        {
          on = [ "<C-e>" ];
          run = "move 999";
          desc = "Go to end";
        }

        # Editing
        {
          on = [ "<Backspace>" ];
          run = "backspace";
          desc = "Delete char before";
        }
        {
          on = [ "<Delete>" ];
          run = "delete";
          desc = "Delete char after";
        }
        {
          on = [ "<C-w>" ];
          run = "backward_kill_word";
          desc = "Delete word before";
        }
        {
          on = [ "<C-u>" ];
          run = "kill_line_before";
          desc = "Delete to start";
        }
        {
          on = [ "<C-k>" ];
          run = "kill_line_after";
          desc = "Delete to end";
        }
      ];

      # Completion dialog keybindings
      completion.keymap = [
        {
          on = [ "<Tab>" ];
          run = "close --submit";
          desc = "Accept completion";
        }
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Cancel";
        }
        {
          on = [ "<C-c>" ];
          run = "close";
          desc = "Cancel";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Next item";
        }
        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Previous item";
        }
        {
          on = [ "<C-n>" ];
          run = "arrow 1";
          desc = "Next item";
        }
        {
          on = [ "<C-p>" ];
          run = "arrow -1";
          desc = "Previous item";
        }
      ];

      # Help dialog keybindings
      help.keymap = [
        {
          on = [ "q" ];
          run = "close";
          desc = "Close help";
        }
        {
          on = [ "<Esc>" ];
          run = "close";
          desc = "Close help";
        }
        {
          on = [ "j" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "k" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "<Down>" ];
          run = "arrow 1";
          desc = "Move down";
        }
        {
          on = [ "<Up>" ];
          run = "arrow -1";
          desc = "Move up";
        }
        {
          on = [ "/" ];
          run = "filter";
          desc = "Filter";
        }
      ];
    };
  };

  # Enable Catppuccin theming
  catppuccin.yazi.enable = true;
}
