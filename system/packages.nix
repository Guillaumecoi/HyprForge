{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [

    # ===== CORE SYSTEM UTILITIES =====
    # Essential CLI tools that should be available system-wide

    home-manager # Home Manager - system-wide installation
    git # Version control - essential for system management
    vim # Classic text editor - always available as fallback
    wget # Download files from web
    curl # Transfer data with URLs
    file # Identify file types
    unzip # Extract ZIP archives
    p7zip # 7-Zip compression
    unrar # Extract RAR archives
    jq # JSON processor

    # ===== SHELL =====

    kitty
    bash # Bourne Again SHell - for scripts
    zsh # Z shell - interactive shell
    fzf # Fuzzy finder

    # ===== HARDWARE SUPPORT =====

    wireplumber # PipeWire session manager
    pavucontrol # Volume control GUI
    # bluez # Bluetooth stack
    # blueman # Bluetooth GUI

    # ===== PROGRAMMING LANGUAGES =====
    python3 # Python interpreter
    python3Packages.pip # Python package installer

    # ===== WAYLAND CORE TOOLS =====

    wl-clipboard-rs # Clipboard utilities (wl-copy/wl-paste)
    wl-clip-persist # Keep clipboard after app closes
    bibata-cursors # Cursor theme (make available system-wide for SDDM)

    # ===== LAPTOP HARDWARE =====

    brightnessctl # Screen brightness control
    powertop # Power monitoring
    tlp # Power management
    acpi # Battery status

  ];
}
