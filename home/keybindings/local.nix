# Local (app-level) keybindings
# These are application-level shortcuts using CTRL/ALT keys
#
# CANONICAL FORMAT: "modifier+key" in lowercase
# Examples: "ctrl+t", "ctrl+shift+t", "alt+1", "shift+tab", "f11"
#
# PHILOSOPHY:
# - CTRL key: Application actions - tabs, editing, navigation
# - ALT key: Quick access - tab numbers, alternative actions, vim alternatives
# - CTRL+ALT: System/AI actions
# - CTRL+SHIFT: Panel sizing, advanced actions
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
    # Toggle panels (ctrl+hjkl)
    left = "ctrl+h"; # Left sidebar (file explorer)
    bottom = "ctrl+j"; # Bottom panel (terminal)
    right = "ctrl+l"; # Right panel (outline, git, etc.)
    top = "ctrl+k"; # Top panel (breadcrumbs, if applicable)

    # Focus panels (ctrl+shift+num is used for resizing, so using ctrl+alt for focus)
    focusLeft = "ctrl+alt+h";
    focusBottom = "ctrl+alt+j";
    focusRight = "ctrl+alt+l";
    focusTop = "ctrl+alt+k";
    focusEditor = "ctrl+shift+;"; # Focus back to editor

    # Panel sizing (inspired by Hyprland's super+shift+hjkl)
    growLeft = "ctrl+shift+h"; # Grow panel/split to the left
    growDown = "ctrl+shift+j"; # Grow panel/split downward
    growUp = "ctrl+shift+k"; # Grow panel/split upward
    growRight = "ctrl+shift+l"; # Grow panel/split to the right
    shrinkLeft = "ctrl+alt+shift+h"; # Shrink from left
    shrinkDown = "ctrl+alt+shift+j"; # Shrink from bottom
    shrinkUp = "ctrl+alt+shift+k"; # Shrink from top
    shrinkRight = "ctrl+alt+shift+l"; # Shrink from right
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
    findInFiles = "ctrl+shift+f"; # Fuzzy search across all files
  };

  # Editing (minimal - use vim defaults, but add standard shortcuts)
  editing = {
    save = "ctrl+s";
    saveAll = "ctrl+alt+s";
    copy = "ctrl+c"; # Copy (standard)
    cut = "ctrl+x"; # Cut (standard)
    paste = "ctrl+v"; # Paste (standard)
    undo = "ctrl+z"; # Undo
    redo = "ctrl+shift+z"; # Redo

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

  # Vim-style applications (Neovim, Yazi, Vimium, etc.)
  # These are standard vim keybindings for consistency across vim-enabled apps
  vimApps = {
    # Leader key
    leader = "space"; # Space as leader key (most discoverable)

    # Tab management (inspired by Vimium/Yazi, with vim standards)
    tabNew = "t"; # New tab (Vimium/Yazi style) - in vim use :tabnew
    tabClose = "x"; # Close tab (Vimium style) - in vim use :tabclose
    tabNext = "gt"; # Next tab (standard vim)
    tabPrev = "gT"; # Previous tab (standard vim) - note: capital T
    tabNextAlt = "shift+j"; # Alternative: Shift+J for next tab
    tabPrevAlt = "shift+k"; # Alternative: Shift+K for previous tab
    tabFirst = "g0"; # First tab (standard vim)
    tabLast = "g$"; # Last tab (standard vim)

    # Navigation (standard vim + alternatives)
    moveLeft = "h"; # Move left (standard vim)
    moveDown = "j"; # Move down (standard vim)
    moveUp = "k"; # Move up (standard vim)
    moveRight = "l"; # Move right (standard vim)

    # Alternative navigation (Alt+hjkl for when Ctrl+hjkl is used for panels)
    moveLeftAlt = "alt+h"; # Move left (alternative)
    moveDownAlt = "alt+j"; # Move down (alternative)
    moveUpAlt = "alt+k"; # Move up (alternative)
    moveRightAlt = "alt+l"; # Move right (alternative)

    # Editing (standard vim + alternatives)
    deleteChar = "x"; # Delete character under cursor
    deleteLine = "dd"; # Delete line
    deleteToEnd = "d$"; # Delete to end of line
    yankLine = "yy"; # Yank (copy) line
    yankToEnd = "y$"; # Yank to end of line
    put = "p"; # Put (paste) after cursor
    putBefore = "shift+p"; # Put before cursor

    # Alternative editing (standard shortcuts alongside vim)
    copyAlt = "ctrl+c"; # Copy (standard shortcut)
    cutAlt = "ctrl+x"; # Cut (standard shortcut)
    pasteAlt = "ctrl+v"; # Paste (standard shortcut)

    undo = "u"; # Undo (standard vim)
    redo = "ctrl+r"; # Redo (standard vim)
    redoAlt = "ctrl+shift+z"; # Redo alternative (standard shortcut)

    # Search (standard vim)
    searchForward = "/"; # Search forward
    searchBackward = "?"; # Search backward
    searchNext = "n"; # Next search result
    searchPrev = "shift+n"; # Previous search result (capital N)
    searchWordUnderCursor = "*"; # Search for word under cursor (forward)
    searchWordBackward = "#"; # Search for word under cursor (backward)

    # Fuzzy search (modern vim with fzf/telescope)
    fuzzyFiles = "ctrl+p"; # Fuzzy file search
    fuzzyBuffers = "ctrl+b"; # Fuzzy buffer search
    fuzzySearch = "ctrl+shift+f"; # Fuzzy text search across files
    fuzzyLines = "ctrl+/"; # Fuzzy search in current buffer

    # Visual mode
    visualMode = "v"; # Visual mode (standard vim)
    visualLineMode = "shift+v"; # Visual line mode (capital V)
    visualBlockMode = "ctrl+v"; # Visual block mode

    # Window/Split management in vim
    splitVertical = "ctrl+backslash"; # Split vertically
    splitHorizontal = "ctrl+shift+backslash"; # Split horizontally

    # Window navigation (Alt since Ctrl+W closes tabs)
    windowLeft = "alt+h";
    windowDown = "alt+j";
    windowUp = "alt+k";
    windowRight = "alt+l";

    # Window resizing (matching panel grow/shrink)
    windowGrowLeft = "ctrl+shift+h";
    windowGrowDown = "ctrl+shift+j";
    windowGrowUp = "ctrl+shift+k";
    windowGrowRight = "ctrl+shift+l";
    windowShrinkLeft = "ctrl+alt+shift+h";
    windowShrinkDown = "ctrl+alt+shift+j";
    windowShrinkUp = "ctrl+alt+shift+k";
    windowShrinkRight = "ctrl+alt+shift+l";

    # File operations
    save = "ctrl+s"; # Save (modern shortcut)
    saveVim = ":w"; # Save (vim command)
    quit = ":q"; # Quit (vim command)
    saveQuit = ":wq"; # Save and quit (vim command)
    forceQuit = ":q!"; # Quit without saving (vim command)
  };
}
