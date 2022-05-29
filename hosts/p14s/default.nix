{ config, pkgs, nixos-hardware, user, ... }:

{
  imports =  [
     nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    ./hardware-configuration.nix
    ../../modules/emacs
  ]; 
  boot.loader.systemd-boot.consoleMode = "max";
  boot.initrd.luks.devices = {
      enc-disk = {
        device = "/dev/disk/by-label/enc-disk";
        preLVM = true;
        allowDiscards = true;
      };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = user;

  environment.systemPackages = with pkgs; [
    vim 
    firefox
    git
    gitflow
    gnumake
    signal-desktop
    element-desktop
  ];

}


