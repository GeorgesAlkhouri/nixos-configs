{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                 
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages
    };

  outputs = inputs @ { self, nixpkgs, ... }:  
    let                                                                     
      user = "dev";
      location = "$HOME/.setup";
    in                                                                      
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user location;                
        }
      );

    };
}
