{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                 
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      nur.url = "github:nix-community/NUR";
      home-manager = {                                                      
        url = "github:nix-community/home-manager/release-22.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, nur, nixpkgs-unstable, ... }:  
    let                                                                     
      user = "dev";
      location = "$HOME/.setup";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        # unstable = import nixpkgs-unstable {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };    
    in                                                                      
      {
        nixosConfigurations = (                                               # NixOS configurations
          import ./hosts {                                                    # Imports ./hosts/default.nix
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs user location nixos-hardware home-manager nur overlay-unstable;                
          }
        );

      };
}
