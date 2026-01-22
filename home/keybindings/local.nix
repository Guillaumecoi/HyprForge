# Local (app-level) keybindings
# These are application-level shortcuts using CTRL/ALT keys
#
# CANONICAL FORMAT: "modifier+key" in lowercase
# Examples: "ctrl+t", "ctrl+shift+t", "alt+1", "shift+tab", "f11"
#
# PHILOSOPHY:
# - CTRL key: Application actions - tabs, editing, navigation
# - ALT key: Quick access - tab numbers, alternative actions
# - CTRL+ALT: System/AI actions
# - Vim keys (hjkl): Navigation in vim-enabled apps
{
  # Tab/window management
  tabs = {
    new = "ctrl+t";
    close = "ctrl+w";
    reopen = "ctrl+shift+t";
    next = "ctrl+tab";
    prev = "ctrl+shift+tab";
    goto1 = "alt+1";
    goto2 = "alt+2";
    goto3 = "alt+3";
    goto4 = "alt+4";
    goto5 = "alt+5";
    goto6 = "alt+6";
    goto7 = "alt+7";
    goto8 = "alt+8";
    goto9 = "alt+9";
    gotoLast = "alt+0";
  };

  # Terminal app specific tabs (for Yazi, Neovim, etc.)
  terminalTabs = {
    close = "ctrl+shift+w";
    next = "alt+ctrl+tab";
    prev = "alt+ctrl+shift+tab";
    goto1 = "alt+shift+1";
    goto2 = "alt+shift+2";
    goto3 = "alt+shift+3";
    goto4 = "alt+shift+4";
    goto5 = "alt+shift+5";
    goto6 = "alt+shift+6";
    goto7 = "alt+shift+7";
    goto8 = "alt+shift+8";
    goto9 = "alt+shift+9";
    gotoLast = "alt+shift+0";
  };

  # Window management (within applications)
  windows = {
    new = "ctrl+n";
    fullscreen = "shift+f11";
    terminal = "ctrl+`";
    terminalNew = "ctrl+shift+`";
  };

  # Panel management (numbered system)
  panels = {
    # Toggle panels (ctrl+num)
    left = "ctrl+h"; # Left sidebar (file explorer)
    bottom = "ctrl+j"; # Bottom panel (terminal)
    right = "ctrl+l"; # Right panel (outline, git, etc.)
    top = "ctrl+k"; # Top panel (breadcrumbs, if applicable)

    # Focus panels (ctrl+shift+num)
    focusLeft = "ctrl+shift+h";
    focusBottom = "ctrl+shift+j";
    focusRight = "ctrl+shift+l";
    focusTop = "ctrl+shift+k";
    focusEditor = "ctrl+shift+;"; # Focus back to editor

    # Panel sizing
    maximizePanel = "ctrl+shift+m";
  };

  # Navigation and search (modern editor shortcuts)
  navigation = {
    goToFile = "ctrl+p";
    goToSymbol = "ctrl+shift+o";
    commandPalette = "ctrl+shift+p";
    urlBar = "ctrl+l"; # For browsers
    find = "ctrl+f"; # Find in current document/page
    findNext = "ctrl+g"; # Next search result
    findPrev = "ctrl+shift+g"; # Previous search result
  };

  # Editing (minimal - use vim defaults)
  editing = {
    save = "ctrl+s";
    saveAll = "ctrl+alt+s";
    copy = "ctrl+c"; # Copy (for browsers - copy URL, etc.)

    # Line operations (VSCode-style, kept by request)
    moveLineUp = "alt+k";
    moveLineUpAlt = "alt+up"; # Arrow alternative
    moveLineDown = "alt+j";
    moveLineDownAlt = "alt+down"; # Arrow alternative
    copyLineUp = "alt+shift+k";
    copyLineUpAlt = "alt+shift+up"; # Arrow alternative
    copyLineDown = "alt+shift+j";
    copyLineDownAlt = "alt+shift+down"; # Arrow alternative
  };

  # Code folding (collapse/expand sections)
  folding = {
    toggle = "ctrl+shift+["; # Toggle fold at cursor
    toggleAll = "ctrl+shift+]"; # Toggle all folds
    fold = "ctrl+shift+["; # Fold region
    unfold = "ctrl+shift+]"; # Unfold region
    foldAll = "ctrl+k ctrl+0"; # Fold all regions
    unfoldAll = "ctrl+k ctrl+j"; # Unfold all regions
  };

  # View/zoom
  view = {
    zoomIn = "ctrl+equal";
    zoomInAlt = "ctrl+plus";
    zoomOut = "ctrl+minus";
    zoomReset = "ctrl+0";
    splitRight = "ctrl+backslash";
    splitDown = "ctrl+shift+backslash";
  };

  # AI Integration
  ai = {
    chat = "ctrl+alt+i"; # Open AI chat/assistant
    inlineChat = "ctrl+i"; # Inline AI suggestions (in editors)
    explain = "ctrl+alt+e"; # Explain selected code
    fix = "ctrl+alt+f"; # Fix/improve selected code
    generate = "ctrl+alt+g"; # Generate code from comment
  };

  # Help and documentation
  help = {
    shortcuts = "ctrl+f1"; # Show app shortcuts/keybindings
  };
}
