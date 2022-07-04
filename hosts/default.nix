{ inputs, overlay-unstable }:

let
  inherit (inputs) home-manager nixpkgs agenix;

  system = "x86_64-linux"; # System architecture
  user = "dev";
  lib = nixpkgs.lib;
in
{

  p14s = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user agenix; };
    modules = [
      # Importing packages from multiple channels
      ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
      ./p14s
      ./base.nix
      agenix.nixosModules.age
    ];
  };

}
