{ lib, inputs, nixpkgs, user, location, ... }:

let
  system = "x86_64-linux";                             	    # System architecture

  pkgs = import nixpkgs {
    inherit system;
  # config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      ./vm
      ./configuration.nix
    ];
  };
}
