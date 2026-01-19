{ config, pkgs, ... }:

let
  user = import ../../../user.nix;
in

{
  # Zsh Configuration
  programs.zsh = {
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    # Session variables are now centralized in home/environment.nix
    # EDITOR, TERMINAL, BROWSER etc. are set there

    # Completion settings
    completionInit = ''
      autoload -U compinit
      compinit

      # Case insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # Better completion behavior
      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache
    '';

    # Add your aliases here
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/HyprForge#${user.hostname}";
      homeswitch = "home-manager switch --flake ~/HyprForge#${user.hostname}";
    };

    # Oh My Zsh provides themes and plugins for zsh
    oh-my-zsh = {
      plugins = [
        "git"
        "sudo"
      ]; # Plugin names from oh-my-zsh repository
    };

    # initContent runs after zsh starts - for shell integrations and environment
    initContent = ''
      # Source user environment variables if the file exists
      [ -f ~/.env ] && source ~/.env

      # Initialize tools
      eval "$(zoxide init zsh)"

      # Autosuggestion settings for better visibility and behavior
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666680,bold"
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      # Keybindings for autocompletion
      bindkey '^I' complete-word              # Tab for completion
      bindkey '^[[Z' reverse-menu-complete    # Shift+Tab for reverse completion
      bindkey '^ ' autosuggest-accept         # Ctrl+Space to accept suggestion
      bindkey '^f' autosuggest-accept         # Ctrl+f to accept suggestion (alternative)
    '';
  };

  # Starship Prompt Configuration
  programs.starship = {
    enableZshIntegration = true;
  };
}
