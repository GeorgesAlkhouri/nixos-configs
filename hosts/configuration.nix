{ config, lib, pkgs, inputs, user, location, ... }:

{

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
    description = "Devvvv!";
    extraGroups = [ "wheel" ];
    createHome = true;
    #  should be the password in an encrypted from
    #  use: `mkpasswd -m sha-512`
    passwordFile = config.age.secrets."passwords/users/dev".path;
    home = "/home/${user}";
  };

  users.users.root.passwordFile = config.age.secrets."passwords/users/root".path;

  age.secrets."passwords/users/dev".file = ../secrets/passwords/users/dev.age;
  age.secrets."passwords/users/root".file = ../secrets/passwords/users/root.age;
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
    };
    stateVersion = "22.05";
  };
}
