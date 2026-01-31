{
  description = "HyprForge - A NixOS configuration for Hyprland users";

  inputs = {
    # Pin to specific commit for reproducibility
    # Update with: nix flake update
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    # NUR for Firefox addons
    nur.url = "github:nix-community/NUR";
  };

  # Allow importing files outside the flake's git tree
  nixConfig = {
    extra-experimental-features = "flakes nix-command";
    allow-import-from-derivation = true;
  };

  outputs =
    { nixpkgs
    , home-manager
    , catppuccin
    , nur
    , ...
    }@inputs:
    let
      # Import user.nix - must be tracked in git for flakes to work
      user = import ./user.nix;
      system = "x86_64-linux";

      # Import unstable packages with unfree software enabled and NUR overlay
      pkgs-unstable = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nur.overlays.default ];
      };
      # Provide a `pkgs` binding (use the unstable set here)
      pkgs = pkgs-unstable;
    in
    {
      nixosConfigurations.${user.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            pkgs-unstable
            catppuccin
            ;
        };
        modules = [
          ./configuration.nix
          # Forward unstable pkgs and theme to Home Manager via a small module
          (
            { pkgs-unstable
            , catppuccin
            , ...
            }:
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs-unstable catppuccin;
              };
            }
          )
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
        ];
      };
      # Expose a Home Manager configuration so `home-manager --flake .#<user>` works
      homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          catppuccin.homeModules.catppuccin
        ];
        extraSpecialArgs = {
          inherit
            inputs
            pkgs-unstable
            catppuccin
            ;
        };
      };
    };
}
