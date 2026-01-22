{
  # Hostname and username configuration
  username = "guillaume";
  hostname = "legion7";

  # System-specific hardware configuration
  hasNvidiaGpu = true;

  # Swap configuration
  swapDevice = "/dev/disk/by-uuid/6e40e034-e983-40c5-ae26-85d239970db0";
  swapSizeGB = 16;

  # Printer configuration (empty list = no printing)
  printerDrivers = [ "epson-escpr2" "epson-escpr" ];

  # Git configuration (to be configured later)
  git = {
    fullName = "GuillaumeCoi";
    email = "GuillaumeCoi@users.noreply.github.com";
  };
}
