# VS Code configuration
# Settings use userSettings which allows user modifications to persist
# Only settings explicitly defined here will be managed
# User changes to other settings will be preserved
#
# Keybindings and vim settings are imported from ./keybindings.nix
# Extensions are imported from ./extensions.nix
# Vim extension configured with Space as leader key
#
# AI Integration: Ctrl+Alt+I opens GitHub Copilot chat

{ pkgs-unstable, lib, ... }:

let
  # Import keybindings (includes both VSCode and vim settings)
  keybindingsModule = import ./keybindings.nix { inherit lib; };
in
{
  programs.vscode = {
    # Allow mutable extensions - user can install extensions via UI
    # Extensions defined in ./extensions.nix are still managed declaratively
    mutableExtensionsDir = true;

    profiles.default.userSettings = {
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.5;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [
        80
        120
      ];
      "editor.wordWrap" = "off";
      "editor.formatOnSave" = true;
      "[nix]"."editor.formatOnSave" = false; # Disable auto-format for Nix (manual format with Shift+Alt+F)
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";

      # File handling
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      # Workbench
      "workbench.startupEditor" = "none";
      "workbench.tree.indent" = 16;

      # Terminal
      "terminal.integrated.defaultProfile.linux" = "zsh";

      # Nix language server
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";

      # Direnv
      "direnv.restart.automatic" = true;

      # Python
      "python.defaultInterpreterPath" = ".venv/bin/python";
      "python.terminal.activateEnvironment" = true;

      # Vim extension - Full vim experience with leader key
      "vim.useSystemClipboard" = true;
      "vim.useCtrlKeys" = true;
      "vim.hlsearch" = true;
      "vim.incsearch" = true;
      "vim.ignorecase" = true;
      "vim.smartcase" = true;
      "vim.leader" = "<space>";
    }
    // keybindingsModule.vimSettings; # Merge vim keybindings from keybindings.nix

    # Keybindings imported from separate file
    profiles.default.keybindings = keybindingsModule.keybindings;

    # Extensions imported from separate file
    profiles.default.extensions = import ./extensions.nix { inherit pkgs-unstable; };
  };

  catppuccin.vscode.profiles.default.enable = true;
}
