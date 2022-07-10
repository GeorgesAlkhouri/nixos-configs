{ config, pkgs, inputs, user, agenix, ... }:

let inherit (inputs) home-manager;

in {

  imports = [ ./hardware-configuration.nix ];

  modules = {
    editors.emacs.enable = true;
    development.enable = true;
    development.python.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = import ./home.nix;
    extraSpecialArgs = { inherit user; };
  };

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

  security.rtkit.enable = true;

  # Enable sound.
  # Make bluetooth head phones work
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.useQtScaling = true;

  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = user;
  # fingerprint sensor
  # services.fprintd.enable = true;
  services.fstrim.enable = true;

  # better power and battery management
  services.tlp.enable = true;

  services.upower.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  programs.dconf.enable = true;

  users.users.${user} = {
    description = "Devvvv!";
    #  should be the password in an encrypted from
    #  use: `mkpasswd -m sha-512`
    passwordFile = config.age.secrets."passwords/users/dev".path;
    extraGroups = [
      "networkmanager"
      "input" # needed for libinput-gestures support
      "libvirtd"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    vagrant
    libreoffice
    vim
    gnumake
    signal-desktop
    element-desktop
    # python39Full
    # python39Packages.virtualenv
    # python39Packages.virtualenvwrapper
    owncloud-client
    clinfo
    libsForQt5.kalendar
    tldr
    powertop
    tlp
    #BEGIN libinput gestures support
    libinput-gestures
    wmctrl # simulates keyboard and mouse actions for Xorg or XWayland based apps
    xdotool
    #END libinput
    firefox
    # apple music player
    cider
    agenix.defaultPackage.x86_64-linux
  ];

  # make sure that boot is available on boot
  # e.g. ssh keys for agenix decryption
  fileSystems."/home".neededForBoot = true;

  users.users.root.passwordFile =
    config.age.secrets."passwords/users/root".path;
  age.secrets."passwords/users/dev".file =
    ../../secrets/passwords/users/dev.age;
  age.secrets."passwords/users/root".file =
    ../../secrets/passwords/users/root.age;
  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

  programs.ssh.startAgent = true;
}

