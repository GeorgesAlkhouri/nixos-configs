{ lib, inputs, nixpkgs, user, location, nixos-hardware, home-manager, nur
, overlay-unstable, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    # config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in {

  p14s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user nixos-hardware nur; };
    modules = [
      # Importing packages from multiple channels
      ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
      ./p14s
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ./p14s/home.nix;
        home-manager.extraSpecialArgs = { inherit user; };
      }
    ];
  };

}
