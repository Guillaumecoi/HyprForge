# VSCode Keybindings
# Vim-centric approach: Most editing via vim mode with leader key
# Only essential non-vim actions defined here (panels, terminal, AI, zoom)
#
# Philosophy:
# - Use vim mode for all text editing, navigation, and tabs
# - Use leader key (Space) for file operations, git, splits, etc.
# - Keep only system-level bindings here (panels, terminal, window management)

{ lib }:

let
  # Import central keybindings with lib for converter functions
  central = import ../../keybindings { inherit lib; };

  # Access pre-converted VSCode keybindings from central
  keys = central.vscode;

  # AI keys need to be converted for VSCode format
  aiKeys = builtins.mapAttrs (n: v: central.converters.toVscode v) central.ai;
in
{
  # VSCode keybindings (applied to keybindings.json)
  keybindings = [
    # Panel management - Ctrl+H/J/K/L (toggle), Ctrl+Alt+H/J/K/L (focus)
    # H=Left sidebar, J=Bottom terminal, K=Top/outline, L=Right auxiliary bar
    {
      key = keys.panels.left;
      command = "workbench.action.toggleSidebarVisibility";
    }
    {
      key = keys.panels.bottom;
      command = "workbench.action.terminal.toggleTerminal";
    }
    {
      key = keys.panels.top;
      command = "breadcrumbs.toggle";
      when = "!inDebugMode";
    }
    {
      key = keys.panels.right;
      command = "workbench.action.toggleAuxiliaryBar";
    }
    {
      key = keys.panels.focusLeft;
      command = "workbench.view.explorer";
    }
    {
      key = keys.panels.focusBottom;
      command = "workbench.action.terminal.focus";
    }
    {
      key = keys.panels.focusTop;
      command = "outline.focus";
    }
    {
      key = keys.panels.focusRight;
      command = "workbench.action.focusAuxiliaryBar";
    }

    # Panel resizing (Ctrl+Shift+hjkl matching Hyprland pattern)
    {
      key = keys.panels.growLeft;
      command = "workbench.action.decreaseViewWidth";
    }
    {
      key = keys.panels.growDown;
      command = "workbench.action.increaseViewHeight";
    }
    {
      key = keys.panels.growUp;
      command = "workbench.action.decreaseViewHeight";
    }
    {
      key = keys.panels.growRight;
      command = "workbench.action.increaseViewWidth";
    }
    {
      key = keys.panels.shrinkLeft;
      command = "workbench.action.increaseViewWidth";
    }
    {
      key = keys.panels.shrinkDown;
      command = "workbench.action.decreaseViewHeight";
    }
    {
      key = keys.panels.shrinkUp;
      command = "workbench.action.increaseViewHeight";
    }
    {
      key = keys.panels.shrinkRight;
      command = "workbench.action.decreaseViewWidth";
    }

    # Help and shortcuts
    {
      key = keys.help.shortcuts;
      command = "workbench.action.openGlobalKeybindings";
    }
    {
      key = keys.panels.focusEditor;
      command = "workbench.action.focusActiveEditorGroup";
    }

    # Terminal (not handled by vim)
    {
      key = keys.windows.terminal;
      command = "workbench.action.terminal.toggleTerminal";
    }
    {
      key = keys.windows.terminalNew;
      command = "workbench.action.terminal.new";
    }

    # Window management (system-level)
    {
      key = keys.windows.new;
      command = "workbench.action.newWindow";
    }
    {
      key = keys.windows.fullscreen;
      command = "workbench.action.toggleFullScreen";
    }

    # View/zoom (system-level)
    {
      key = keys.view.zoomIn;
      command = "workbench.action.zoomIn";
    }
    {
      key = keys.view.zoomOut;
      command = "workbench.action.zoomOut";
    }
    {
      key = keys.view.zoomReset;
      command = "workbench.action.zoomReset";
    }

    # Tab operations - Aligned with local.nix
    {
      key = keys.tabs.new;
      command = "workbench.action.files.newUntitledFile";
    }
    {
      key = keys.tabs.close;
      command = "workbench.action.closeActiveEditor";
    }
    {
      key = keys.tabs.reopen;
      command = "workbench.action.reopenClosedEditor";
    }
    {
      key = keys.tabs.next;
      command = "workbench.action.nextEditor";
    }
    {
      key = keys.tabs.prev;
      command = "workbench.action.previousEditor";
    }

    # Tab navigation by number (Alt+1-9, Alt+0)
    {
      key = keys.tabs.goto1;
      command = "workbench.action.openEditorAtIndex1";
    }
    {
      key = keys.tabs.goto2;
      command = "workbench.action.openEditorAtIndex2";
    }
    {
      key = keys.tabs.goto3;
      command = "workbench.action.openEditorAtIndex3";
    }
    {
      key = keys.tabs.goto4;
      command = "workbench.action.openEditorAtIndex4";
    }
    {
      key = keys.tabs.goto5;
      command = "workbench.action.openEditorAtIndex5";
    }
    {
      key = keys.tabs.goto6;
      command = "workbench.action.openEditorAtIndex6";
    }
    {
      key = keys.tabs.goto7;
      command = "workbench.action.openEditorAtIndex7";
    }
    {
      key = keys.tabs.goto8;
      command = "workbench.action.openEditorAtIndex8";
    }
    {
      key = keys.tabs.goto9;
      command = "workbench.action.openEditorAtIndex9";
    }
    {
      key = keys.tabs.gotoLast;
      command = "workbench.action.lastEditorInGroup";
    }

    # AI Integration (GitHub Copilot) - from central.ai keybindings
    {
      key = aiKeys.chat;
      command = "workbench.panel.chat.view.copilot.focus";
    }
    {
      key = aiKeys.inlineChat;
      command = "inlineChat.start";
      when = "editorTextFocus";
    }
    {
      key = aiKeys.explain;
      command = "github.copilot.interactiveEditor.explain";
      when = "editorTextFocus";
    }
    {
      key = aiKeys.fix;
      command = "github.copilot.interactiveEditor.fix";
      when = "editorTextFocus";
    }
    {
      key = aiKeys.generate;
      command = "github.copilot.interactiveEditor.generate";
      when = "editorTextFocus";
    }
  ];

  # Vim extension settings (applied to userSettings)
  vimSettings = {
    # Insert mode mappings
    "vim.insertModeKeyBindings" = [
      {
        "before" = [
          "j"
          "j"
        ];
        "after" = [ "<Esc>" ];
      }
    ];

    # Normal mode leader key mappings (vim-style)
    "vim.normalModeKeyBindingsNonRecursive" = [
      # File operations (<leader>w, <leader>q)
      {
        "before" = [
          "<leader>"
          "w"
        ];
        "commands" = [ "workbench.action.files.save" ];
      }
      {
        "before" = [
          "<leader>"
          "q"
        ];
        "commands" = [ "workbench.action.closeActiveEditor" ];
      }
      {
        "before" = [
          "<leader>"
          "Q"
        ];
        "commands" = [ "workbench.action.closeAllEditors" ];
      }

      # Find/search (<leader>f, <leader>/)
      {
        "before" = [
          "<leader>"
          "f"
        ];
        "commands" = [ "workbench.action.quickOpen" ];
      }
      {
        "before" = [
          "<leader>"
          "/"
        ];
        "commands" = [ "workbench.action.findInFiles" ];
      }
      {
        "before" = [
          "<leader>"
          "b"
        ];
        "commands" = [ "workbench.action.showAllEditorsByMostRecentlyUsed" ];
      }
      {
        "before" = [
          "<leader>"
          "s"
        ];
        "commands" = [ "workbench.action.gotoSymbol" ];
      }

      # Panels/views (<leader>e, <leader>`)
      {
        "before" = [
          "<leader>"
          "e"
        ];
        "commands" = [ "workbench.view.explorer" ];
      }
      {
        "before" = [
          "<leader>"
          "`"
        ];
        "commands" = [ "workbench.action.terminal.toggleTerminal" ];
      }
      {
        "before" = [
          "<leader>"
          "x"
        ];
        "commands" = [ "workbench.actions.view.problems" ];
      }
      {
        "before" = [
          "<leader>"
          "o"
        ];
        "commands" = [ "outline.focus" ];
      }

      # Splits (<leader>v, <leader>h)
      {
        "before" = [
          "<leader>"
          "v"
        ];
        "commands" = [ "workbench.action.splitEditor" ];
      }
      {
        "before" = [
          "<leader>"
          "h"
        ];
        "commands" = [ "workbench.action.splitEditorDown" ];
      }
      {
        "before" = [
          "<leader>"
          "c"
        ];
        "commands" = [ "workbench.action.closeActiveEditor" ];
      }

      # Git (<leader>g)
      {
        "before" = [
          "<leader>"
          "g"
          "s"
        ];
        "commands" = [ "workbench.view.scm" ];
      }
      {
        "before" = [
          "<leader>"
          "g"
          "b"
        ];
        "commands" = [ "gitlens.toggleLineBlame" ];
      }
      {
        "before" = [
          "<leader>"
          "g"
          "c"
        ];
        "commands" = [ "git.commit" ];
      }
      {
        "before" = [
          "<leader>"
          "g"
          "p"
        ];
        "commands" = [ "git.push" ];
      }

      # Code actions (<leader>l for LSP/language)
      {
        "before" = [
          "<leader>"
          "l"
          "f"
        ];
        "commands" = [ "editor.action.formatDocument" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "r"
        ];
        "commands" = [ "editor.action.rename" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "a"
        ];
        "commands" = [ "editor.action.quickFix" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "d"
        ];
        "commands" = [ "editor.action.revealDefinition" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "R"
        ];
        "commands" = [ "references-view.findReferences" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "h"
        ];
        "commands" = [ "editor.action.showHover" ];
      }

      # Command palette
      {
        "before" = [
          "<leader>"
          "p"
        ];
        "commands" = [ "workbench.action.showCommands" ];
      }
    ];

    # Visual mode leader mappings
    "vim.visualModeKeyBindingsNonRecursive" = [
      # Code actions on selection
      {
        "before" = [
          "<leader>"
          "l"
          "f"
        ];
        "commands" = [ "editor.action.formatSelection" ];
      }
      {
        "before" = [
          "<leader>"
          "l"
          "a"
        ];
        "commands" = [ "editor.action.quickFix" ];
      }
    ];

    # Vim standard keybindings (gt/gT for tabs, Alt+hjkl for window navigation)
    "vim.normalModeKeyBindings" = [
      # Tab/Buffer navigation (gt/gT like standard vim)
      {
        "before" = [ "g" "t" ];
        "commands" = [ "workbench.action.nextEditor" ];
      }
      {
        "before" = [ "g" "T" ];
        "commands" = [ "workbench.action.previousEditor" ];
      }
      {
        "before" = [ "g" "0" ];
        "commands" = [ "workbench.action.openEditorAtIndex1" ];
      }
      {
        "before" = [ "g" "$" ];
        "commands" = [ "workbench.action.lastEditorInGroup" ];
      }

      # Alternative tab navigation (Shift+J/K)
      {
        "before" = [ "<S-j>" ];
        "commands" = [ "workbench.action.nextEditor" ];
      }
      {
        "before" = [ "<S-k>" ];
        "commands" = [ "workbench.action.previousEditor" ];
      }

      # Alternative window navigation (Alt+hjkl)
      {
        "before" = [ "<A-h>" ];
        "commands" = [ "workbench.action.navigateLeft" ];
      }
      {
        "before" = [ "<A-j>" ];
        "commands" = [ "workbench.action.navigateDown" ];
      }
      {
        "before" = [ "<A-k>" ];
        "commands" = [ "workbench.action.navigateUp" ];
      }
      {
        "before" = [ "<A-l>" ];
        "commands" = [ "workbench.action.navigateRight" ];
      }
    ];

    # Let vim handle most keys, but preserve system-level bindings
    "vim.handleKeys" = {
      # Panel management (toggle)
      "<C-h>" = false;
      "<C-j>" = false;
      "<C-k>" = false;
      "<C-l>" = false;

      # Panel focus
      "<C-A-h>" = false;
      "<C-A-j>" = false;
      "<C-A-k>" = false;
      "<C-A-l>" = false;

      # Panel resizing (Ctrl+Shift+hjkl)
      "<C-S-h>" = false;
      "<C-S-j>" = false;
      "<C-S-k>" = false;
      "<C-S-l>" = false;
      "<C-A-S-h>" = false;
      "<C-A-S-j>" = false;
      "<C-A-S-k>" = false;
      "<C-A-S-l>" = false;
      "<C-S-;>" = false;

      # Zoom
      "<C-=>" = false;
      "<C-+>" = false;
      "<C-->" = false;
      "<C-0>" = false;

      # Window management
      "<C-A-n>" = false;
      "<C-t>" = false;
      "<C-S-t>" = false;
      "<S-F11>" = false;

      # Tab operations
      "<C-n>" = false;
      "<C-w>" = false;
      "<C-S-n>" = false;
      "<C-Tab>" = false;
      "<C-S-Tab>" = false;

      # Tab number navigation
      "<A-1>" = false;
      "<A-2>" = false;
      "<A-3>" = false;
      "<A-4>" = false;
      "<A-5>" = false;
      "<A-6>" = false;
      "<A-7>" = false;
      "<A-8>" = false;
      "<A-9>" = false;
      "<A-0>" = false;

      # AI integration
      "<C-A-i>" = false;
      "<C-i>" = false;
      "<C-A-e>" = false;
      "<C-A-f>" = false;
      "<C-A-g>" = false;

      # Navigation
      "<C-p>" = false;
      "<C-S-p>" = false;
      "<C-S-o>" = false;

      # Editing
      "<C-s>" = false;
      "<C-A-s>" = false;
    };
  };
}
