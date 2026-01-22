{ pkgs, pkgs-unstable }:

# Unified list of ALL programs to install
# Programs with HM modules (in managed-programs.nix) will auto-use programs.<name>.enable
# Others will be installed as bare packages via home.packages
# Programs with custom configs stay in home/programs/<name>/<name>.nix

[
  # ===== DEVELOPMENT ===== #

  # Editors & IDEs
  "micro" # Modern terminal editor - nano alternative
  "neovim" # Vim-based terminal editor
  "vscode" # VSCode editor

  # Version Control
  "git" # Git version control
  "gh" # GitHub CLI
  "lazygit" # Terminal git UI
  "delta" # Better git diff

  # Containers
  "podman" # Rootless containers
  "podman-compose" # Docker Compose for Podman
  "podman-tui" # Terminal UI for Podman

  # Development
  "direnv" # Environment switcher
  "nixfmt-rfc-style" # Nix code formatter
  "nixpkgs-fmt" # Nixpkgs formatter
  "nixd" # Nix language server backend
  "taplo" # TOML formatter
  "nodePackages.prettier" # Prettier for JSON/CSS formatting
  "nodejs" # Node.js runtime
  "appimage-run" # Lets you run appimages

  # API & HTTP Tools
  "httpie" # HTTP CLI client
  "python313Packages.grequests" # Async HTTP requests in Python (used by weather.py)

  # AI Assistants
  "github-copilot-cli" # GitHub Copilot CLI
  "claude-code" # Claude AI CLI

  # Shell & Terminal
  "zsh" # Zsh shell
  "oh-my-zsh" # Zsh framework
  "kitty" # GPU accalerated terminal emulator
  "starship" # Prompt
  "zoxide" # Smarter cd command
  "ripgrep" # Faster grep
  "fzf" # Fuzzy finder
  "bat" # Cat clone with syntax highlighting
  "fd" # Faster find

  # ===== DESKTOP ENVIRONMENT (WAYLAND/HYPRLAND) ===== #

  # Core Desktop
  "swww" # Sway/Wayland wallpaper setter
  "waybar" # Status bar for Wayland
  "rofi" # Application launcher
  "bibata-cursors" # Cursor theme
  "dunst" # Notification daemon
  "nwg-displays" # Display configuration GUI
  "gtk" # GTK runtime (for GTK apps)
  "wlogout" # Logout/suspend/shutdown menu
  "hyprlock" # Screen locker for Hyprland

  # Utilities
  "hyprpicker" # Color picker
  "cliphist" # Clipboard history

  # ===== SYSTEM UTILITIES ===== #

  # System Monitoring
  "btop" # System monitor TUI
  "fastfetch" # System info display
  "gnome-system-monitor" # System monitor GUI
  "hwinfo" # Hardware information
  "lshw" # List hardware

  # Disk & Storage
  "yazi" # Terminal file explorer
  "xfce.thunar" # Xfce file manager
  "ncdu" # Disk usage analyzer
  "gnome-disk-utility" # Disk manager
  "popsicle" # USB flasher
  "kdePackages.ark" # Archive manager
  # "kdePackages.dolphin" # KDE file manager
  # "nautilus" # GNOME file manager

  # ===== SECURITY & SECRETS ===== #

  # Password manager (Bitwarden) and essential tooling
  "bitwarden-cli" # Bitwarden CLI (primary interface for scripts)
  "bitwarden-desktop" # optional GUI client (uncomment if desired)

  # keyring and secret management tools
  "gnome-keyring" # Keyring service (for desktop integration)
  "seahorse" # GUI for managing keyrings and passwords
  "libsecret" # Secret Service library (for desktop integrations)

  # Minimal CLI tooling to integrate secrets into workflows
  "gnupg" # GPG for encrypted workflows
  "age" # Modern encryption tool

  # ===== MULTIMEDIA ===== #

  # Screenshots & Screen Capture
  "grim" # Screenshots
  "slurp" # Screen region selector
  "wayfreeze" # Freeze screen for screenshots
  "satty" # Screenshot annotation
  # "wf-recorder" # Screen recording
  # "obs-studio" # Advanced screen recording/streaming

  # Media Players
  "vlc" # VLC media player
  "mpv" # Lightweight player
  "imv" # Image viewer

  # Media Processing
  "ffmpeg" # Video/audio converter
  "imagemagick" # Image manipulation
  "poppler" # PDF utilities
  "resvg" # SVG rendering

  # ===== DEVICE CONNECTIVITY ===== #

  "libmtp" # Android MTP
  "gphoto2" # Camera support
  "libgphoto2" # Camera library
  "kdePackages.kdeconnect-kde" # Phone integration

  # ===== INTERNET & COMMUNICATION ===== #

  # Web Browsers
  "firefox" # Web browser
  "brave" # Privacy-focused chrome browser
  # "chromium" # Open-source Chrome
  # "tor-browser" # Anonymous browsing

  # Messaging & Communication
  "signal-desktop" # Secure messaging
  "telegram-desktop" # Cloud messaging
  "webcord" # Open Discord client
  # "slack" # Work communication

  # ===== PRODUCTIVITY ===== #

  # Office Suites
  "libreoffice-fresh" # Office suite
  # "onlyoffice-desktopeditors" # MS Office compatible

  # Document Viewers
  # "kdePackages.okular" # Universal viewer (PDF, ePub, etc.)
  # "evince" # GNOME PDF viewer
  "zathura" # Minimal vim-style viewer

  # Email
  # "thunderbird" # Email client

  # Note-Taking
  "obsidian" # Markdown notes
  # "joplin-desktop" # Evernote alternative
  # "logseq" # Outliner notes
  # "anki" # Flashcards

  # Task management
  "super-productivity" # Task manager & pomodoro
  "taskwarrior3" # Task management (modern version)
  "taskwarrior-tui" # TUI for taskwarrior

  # ===== GAMING ===== #

  # "steam" # Steam platform
  # "lutris" # Multi-platform launcher (Epic, GOG, etc.)
  # "heroic" # Epic/GOG launcher
  # "gamemode" # Gaming optimization
  # "mangohud" # Performance overlay
]
