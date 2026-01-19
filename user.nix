{
  # Hostname and username configuration
  username = "guillaume";
  hostname = "laptop-asus-i7";

  # System-specific hardware configuration
  hasNvidiaGpu = true; # Set to true if you have NVIDIA GPU

  # Swap configuration
  # Use the swap partition by stable UUID (set to null to disable)
  swapDevice = "/dev/disk/by-uuid/f1bb39a4-4a43-427c-95b2-c5d08b774027"; # Path to swap file/partition (set to null to disable)
  swapSizeGB = 8; # Swap size in GB (only used if swapDevice is a file)

  # Printer configuration  
  printerDrivers = [ "epson-escpr2" "epson-escpr" ]; # List of printer driver package names (empty list = no printing)

  # Git configuration
  git = {
    fullName = "GuillaumeCoi";
    email = "GuillaumeCoi@users.noreply.github.com";
  };
}
