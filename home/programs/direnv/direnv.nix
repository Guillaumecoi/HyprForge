{ config, pkgs, ... }:

{
  # Enable direnv for automatic dev environment loading
  programs.direnv = {
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
