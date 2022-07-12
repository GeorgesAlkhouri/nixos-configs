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

  # battery charge threshold 
  # https://askubuntu.com/questions/34452/how-can-i-limit-battery-charging-to-80-capacity
  # define lid close behavior
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
  };
  # let systemd put down host to hibernate after x min
  systemd.sleep.extraConfig = "HibernateDelaySec=20min";

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;
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

  services.xserver.enable = true;

  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  security.pam.services.gdm.enableKwallet = true;
  services.xserver.displayManager.defaultSession = "gnome";
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = user;
  services.xserver.desktopManager.gnome.enable = true;

  # fingerprint sensor
  # services.fprintd.enable = true;
  services.fstrim.enable = true;

  # better power and battery management
  # TODO: check if should be used with gnome's internal power manager
  # services.tlp.enable = true;

  services.upower.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  # enable gnome config
  programs.dconf.enable = true;

  users.users.${user} = {
    description = "Devvvv!";
    #  should be the password in an encrypted from
    #  use: `mkpasswd -m sha-512`
    passwordFile = config.age.secrets."passwords/users/dev".path;
    extraGroups = [
      "networkmanager"
      # "input" # needed for libinput-gestures support
      "libvirtd"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    gnomeExtensions.hibernate-status-button
    virt-manager
    vagrant
    vim
    gnumake
    signal-desktop
    element-desktop-wayland
    clinfo
    tldr
    powertop
    # tlp

    # TODO: re-enable browser gestures
    #BEGIN libinput gestures support
    # libinput-gestures
    # wmctrl # simulates keyboard and mouse actions for Xorg or XWayland based apps
    # xdotool
    #END libinput
    firefox-wayland
    # apple music player
    # cider
    agenix.defaultPackage.x86_64-linux
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome.epiphany
    gnome.gnome-music
    gnome.geary
    gnome-photos
    gnome-tour
  ]);

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

