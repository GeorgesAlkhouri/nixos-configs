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

  # Systemd
  systemd.sleep.extraConfig = "HibernateDelaySec=20min";

  # Monitor
  # service.autorandr = {
  #   enable = true;
  #   hooks.postswitch = ''
  #   echo "test" > /home/dev/autorand-test
  #   '';
  # };

  security.rtkit.enable = true;

  # Enable sound.
  sound.enable = true;
  # Make bluetooth head phones work
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

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
  services.upower.enable = true;

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
    tldr
    powertop
    #BEGIN libinput gestures support
    libinput-gestures
    wmctrl # simulates keyboard and mouse actions for Xorg or XWayland based apps
    xdotool
    #END libinput
    firefox
    autorandr
  ];

}


