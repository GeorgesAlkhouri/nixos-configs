{ config, pkgs, nixos-hardware, user, nur, ... }:

{

  imports = [
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
  hardware.bluetooth.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = user;
  services.fprintd.enable = true;
  services.fstrim.enable = true;


  # services.tlp.enable = true;
  # services.tlp.settings = {};
  powerManagement.powertop.enable = true;

  nixpkgs.overlays = [ nur.overlay ];


  users.users.${user} = {
    extraGroups = [ "input" ]; # needed for libinput-gestures support
  };

  environment.systemPackages = with pkgs; [
    libreoffice
    vim
    gnumake
    signal-desktop
    element-desktop
    virtualbox
    python38
    virtualenv
    python38Packages.virtualenvwrapper
    owncloud-client
    ansible
    clinfo
    libsForQt5.kalendar
    #BEGIN libinput gestures support
    libinput-gestures
    wmctrl # simulates keyboard and mouse actions for Xorg or XWayland based apps
    xdotool
    #END libinput
    firefox
  ] ++ [
    pkgs.unstable.nodePackages.pyright
  ];

}


