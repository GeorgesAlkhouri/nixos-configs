{ config, lib, pkgs, inputs, user, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/editors/emacs.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      # Extra locale settings that need to be overwritten
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };

  users.mutableUsers = false;
  users.users.${user} = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/${user}";
  };
  # security.pam.enableEcryptfs = true;

  security.sudo.wheelNeedsPassword = false;

  nix = {
    # Nix Package Manager settings
    autoOptimiseStore = true; # Optimise syslinks
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;
  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";
      flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
      flake = "github:GeorgesAlkhouri/nixos-configs";
    };
    stateVersion = "22.05";
  };
}
