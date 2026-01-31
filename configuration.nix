{ config
, lib
, pkgs
, pkgs-unstable
, theme
, catppuccin
, ...
}:

let
  user = import ./user.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./system/packages.nix
    ./system/fonts.nix
    ./system/services.nix
    ./system/sddm.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = user.hostname;
  networking.networkmanager.enable = true;

  # Ensure display manager and system services see the cursor variables
  # This fixes cursor theme not applying in some display managers (SDDM, GDM)
  # Variables set here are available system-wide before user sessions start
  environment.variables = {
    XCURSOR_THEME = "Bibata";
    XCURSOR_SIZE = "24";
  };

  time.timeZone = "Europe/Brussels";

  # Printing services - conditional based on user.nix
  # Only enabled if printerDrivers list is not empty in user.nix
  # Add printer driver package names to user.nix (e.g., "epson-escpr2")
  services.printing = {
    enable = (builtins.length user.printerDrivers) > 0;
    drivers = map (drv: builtins.getAttr drv pkgs) user.printerDrivers;
  };

  # Enable network printer discovery
  services.avahi = lib.mkIf ((builtins.length user.printerDrivers) > 0) {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.gvfs.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portal for proper Wayland app integration
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Enable RealtimeKit for better audio/video performance
  # Fixes xdg-desktop-portal warnings about missing RealtimeKit
  security.rtkit.enable = true;

  # Enable PAM authentication for screen locking
  # Required for hyprlock to verify passwords when unlocking
  security.pam.services.hyprlock = { };

  # Enable gnome-keyring for application secret storage
  # Used by browsers, Discord, and other apps that need secure credential storage
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Enable automatic trim
  services.fstrim.enable = true;

  # Graphics configuration for gaming and GPU acceleration
  # enable32Bit is required for 32-bit games via Wine/Proton and Steam
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Wine/Steam Proton games
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Home Manager module configuration
  home-manager.backupFileExtension = "backup";

  users.users.${user.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      # "docker"                   # Uncomment if using Docker
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Conditional NVIDIA configuration
  services.xserver.videoDrivers = lib.mkIf user.hasNvidiaGpu [ "nvidia" ];

  hardware.nvidia = lib.mkIf user.hasNvidiaGpu {
    modesetting.enable = true;
    open = false; # Use proprietary driver for better performance
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
