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
      ./configuration.nix
      agenix.nixosModules.age
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
