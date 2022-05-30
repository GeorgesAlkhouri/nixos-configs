{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                 
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";                  # Nix Packages
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      nur.url = "github:nix-community/NUR";
      home-manager = {                                                      
        url = "github:nix-community/home-manager/release-21.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, nur, ... }:  
    let                                                                     
      user = "dev";
      location = "$HOME/.setup";
    in                                                                      
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location nixos-hardware home-manager nur;                
        }
      );

    };
}
