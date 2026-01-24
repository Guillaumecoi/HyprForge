{ config
, pkgs
, lib
, ...
}:

let

in
{
  # Brave Browser Configuration
  # Note: Brave uses Chromium's configuration structure
  programs.chromium = {

    # Browser extensions (Chromium Web Store IDs)
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; } # Catppuccin Theme (Mocha)
    ];

    # Command line arguments
    commandLineArgs = [
      # Hardware acceleration
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"

      # Wayland support
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"

      # Performance
      "--enable-gpu-rasterization"
      "--enable-zero-copy"

      # Privacy
      "--disable-background-networking"
      "--disable-breakpad"

      # Dark mode
      "--force-dark-mode"
    ];
  };
}
