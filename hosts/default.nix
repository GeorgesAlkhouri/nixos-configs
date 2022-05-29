{ lib, inputs, nixpkgs, user, location, nixos-hardware, ... }:

let
  system = "x86_64-linux";                             	    # System architecture

  pkgs = import nixpkgs {
    inherit system;
  # config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{

  p14s = lib.nixosSystem {                                    
    inherit system;
    specialArgs = { inherit inputs user nixos-hardware; };
    modules = [
      ./p14s
      ./configuration.nix
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location; };
    modules = [
      ./vm
      ./configuration.nix
    ];
  };
}
