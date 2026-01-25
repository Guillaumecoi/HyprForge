# Yazi file manager configuration
# Keybindings use Yazi 0.3+ format (manually created)
# Note: Yazi is a TUI file manager with vim-like defaults

{ config
, pkgs
, lib
, ...
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
  };

  # Manually create keymap.toml with yazi 0.3+ format
  # Yazi 0.3+ uses [mgr], [input], etc. sections (not [[manager.keymap]])
  # We only define custom keybindings - yazi provides excellent defaults
  home.file.".config/yazi/keymap.toml".text = ''
    # Yazi keymap configuration (Yazi 0.3+ format)
    # Custom keybindings from central keybindings system

    [mgr]
    keymap = [
      # Navigation - vim style (standard hjkl)
      { on = "h",       run = "leave",     desc = "Go to parent directory" },
      { on = "j",       run = "arrow 1",   desc = "Move down" },
      { on = "k",       run = "arrow -1",  desc = "Move up" },
      { on = "l",       run = "enter",     desc = "Enter directory" },

      # Alternative navigation (Alt+hjkl)
      { on = "<A-h>",   run = "leave",     desc = "Go to parent directory (Alt)" },
      { on = "<A-j>",   run = "arrow 1",   desc = "Move down (Alt)" },
      { on = "<A-k>",   run = "arrow -1",  desc = "Move up (Alt)" },
      { on = "<A-l>",   run = "enter",     desc = "Enter directory (Alt)" },

      # Arrow keys
      { on = "<Left>",  run = "leave",     desc = "Go to parent directory" },
      { on = "<Right>", run = "enter",     desc = "Enter directory" },
      { on = "<Up>",    run = "arrow -1",  desc = "Move up" },
      { on = "<Down>",  run = "arrow 1",   desc = "Move down" },

      # Page navigation
      { on = "<C-u>",      run = "arrow -50%",  desc = "Half page up" },
      { on = "<C-d>",      run = "arrow 50%",   desc = "Half page down" },
      { on = "<PageUp>",   run = "arrow -100%", desc = "Page up" },
      { on = "<PageDown>", run = "arrow 100%",  desc = "Page down" },

      # Jump to top/bottom
      { on = [ "g", "g" ], run = "arrow top", desc = "Jump to top" },
      { on = "G",          run = "arrow bot", desc = "Jump to bottom" },

      # File operations
      { on = "<Enter>", run = "open",                       desc = "Open file" },
      { on = "o",       run = "open",                       desc = "Open file" },
      { on = "O",       run = "open --interactive",         desc = "Open with..." },

      # Copy/Cut/Paste (vim style)
      { on = "y",       run = "yank",                       desc = "Yank (copy)" },
      { on = "x",       run = "yank --cut",                 desc = "Cut" },
      { on = "p",       run = "paste",                      desc = "Paste" },
      { on = "P",       run = "paste --force",              desc = "Paste (overwrite)" },

      # Alternative copy/cut/paste (standard shortcuts)
      { on = "<C-c>",   run = "yank",                       desc = "Copy (Ctrl+C)" },
      { on = "<C-x>",   run = "yank --cut",                 desc = "Cut (Ctrl+X)" },
      { on = "<C-v>",   run = "paste",                      desc = "Paste (Ctrl+V)" },

      # Delete/remove
      { on = "d",       run = "remove",                     desc = "Move to trash" },
      { on = "D",       run = "remove --permanently",       desc = "Delete permanently" },
      { on = "a",       run = "create",                     desc = "Create file/dir" },
      { on = "r",       run = "rename --cursor=before_ext", desc = "Rename" },

      # Selection
      { on = "<Space>", run = [ "toggle", "arrow 1" ], desc = "Toggle selection" },
      { on = "v",       run = "visual_mode",           desc = "Visual mode" },
      { on = "V",       run = "visual_mode --unset",   desc = "Exit visual mode" },
      { on = "<C-a>",   run = "toggle_all --state=on", desc = "Select all" },

      # Search (standard vim + fuzzy)
      { on = "/", run = "search fd", desc = "Search files by name" },
      { on = "?", run = "search rg", desc = "Search file contents" },
      { on = "n", run = "search_next", desc = "Next search result" },
      { on = "N", run = "search_prev", desc = "Previous search result" },
      { on = "<C-p>", run = "search fd", desc = "Fuzzy file search (Ctrl+P)" },
      { on = "<C-S-f>", run = "search rg", desc = "Fuzzy content search (Ctrl+Shift+F)" },

      # Tab management (vim-style + standard)
      { on = "t",       run = "tab_create",               desc = "New tab" },
      { on = "<Tab>",   run = "tab_switch 1 --relative",  desc = "Next tab" },
      { on = "<S-Tab>", run = "tab_switch -1 --relative", desc = "Previous tab" },

      # Vim standard tab navigation
      { on = [ "g", "t" ], run = "tab_switch 1 --relative", desc = "Next tab (gt)" },
      { on = [ "g", "T" ], run = "tab_switch -1 --relative", desc = "Previous tab (gT)" },

      # Alternative tab navigation (Shift+J/K)
      { on = "<S-j>", run = "tab_switch 1 --relative", desc = "Next tab (Shift+J)" },
      { on = "<S-k>", run = "tab_switch -1 --relative", desc = "Previous tab (Shift+K)" },

      # Tab numbers (1-9)
      { on = "1",       run = "tab_switch 0", desc = "Go to tab 1" },
      { on = "2",       run = "tab_switch 1", desc = "Go to tab 2" },
      { on = "3",       run = "tab_switch 2", desc = "Go to tab 3" },
      { on = "4",       run = "tab_switch 3", desc = "Go to tab 4" },
      { on = "5",       run = "tab_switch 4", desc = "Go to tab 5" },
      { on = "6",       run = "tab_switch 5", desc = "Go to tab 6" },
      { on = "7",       run = "tab_switch 6", desc = "Go to tab 7" },
      { on = "8",       run = "tab_switch 7", desc = "Go to tab 8" },
      { on = "9",       run = "tab_switch 8", desc = "Go to tab 9" },

      # Sorting
      { on = [ ",", "m" ], run = "sort modified --reverse", desc = "Sort by modified" },
      { on = [ ",", "n" ], run = "sort natural",            desc = "Sort by name" },
      { on = [ ",", "s" ], run = "sort size --reverse",     desc = "Sort by size" },
      { on = [ ",", "e" ], run = "sort extension",          desc = "Sort by extension" },

      # Goto shortcuts
      { on = [ "g", "h" ], run = "cd ~",            desc = "Go home" },
      { on = [ "g", "c" ], run = "cd ~/.config",    desc = "Go to config" },
      { on = [ "g", "d" ], run = "cd ~/Downloads",  desc = "Go to downloads" },
      { on = [ "g", "D" ], run = "cd ~/Documents",  desc = "Go to documents" },
      { on = [ "g", "p" ], run = "cd ~/Projects",   desc = "Go to projects" },
      { on = [ "g", "/" ], run = "cd /",            desc = "Go to root" },

      # Misc
      { on = ".",     run = "hidden toggle", desc = "Toggle hidden files" },
      { on = "q",     run = "quit",          desc = "Quit" },
      { on = "<Esc>", run = "escape",        desc = "Escape/Cancel" },
      { on = "<C-r>", run = "refresh",       desc = "Refresh" },
      { on = "<F5>",  run = "refresh",       desc = "Refresh" },
      { on = ":",     run = "shell --interactive",         desc = "Shell command" },
      { on = "!",     run = "shell --block --interactive", desc = "Shell command (blocking)" },

      # Custom keybindings from central config
      { on = "${keys.windows.terminal}", run = "shell 'kitty --working-directory \"$PWD\" &' --confirm", desc = "Open terminal here" },
      { on = "${keys.tabs.close}",       run = "close",                desc = "Close current tab" },
      { on = "${keys.ai.chat}",          run = "shell 'cd \"$PWD\" && ${aiCli}' --block --confirm", desc = "Open AI assistant" },
      { on = "${keys.help.shortcuts}",   run = "help",                 desc = "Show help (Ctrl+F1)" },
      { on = "<F1>",                     run = "help",                 desc = "Show help (F1)" },
    ]
  '';

  # Enable Catppuccin theming
  catppuccin.yazi.enable = true;
}
