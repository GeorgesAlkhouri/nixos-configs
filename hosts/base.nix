{
  pkgs,
  inputs,
  user,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/options.nix
    ../modules/xdg.nix
    ../modules/editors/emacs.nix
    ../modules/development
    ../modules/development/python.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 10;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;

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
    extraGroups = ["wheel"];
    createHome = true;
    home = "/home/${user}";
  };

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
    extraOptions = "experimental-features = nix-command flakes";
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";
      flags = ["--update-input" "nixpkgs" "--commit-lock-file"];
      flake = "github:GeorgesAlkhouri/nixos-configs";
    };
    stateVersion = "22.05";
  };

  # base packages
  environment.systemPackages = with pkgs; [vim gnumake git];
}
