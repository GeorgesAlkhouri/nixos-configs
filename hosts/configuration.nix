{ config, lib, pkgs, inputs, user, location, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  system.stateVersion = "21.11"; # Did you read the comment?
  
  users.mutableUsers = false;
  users.users.${user} = {       
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "test1234";
  };
  security.sudo.wheelNeedsPassword = false;

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };


}
