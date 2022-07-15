{
  config,
  pkgs,
  inputs,
  user,
  agenix,
  ...
}: let
  inherit (inputs) home-manager;
in {
  imports = [./hardware-configuration.nix];

  modules = {
    editors.emacs.enable = true;
    editors.emacs.usePgtk = true;
    development.enable = true;
    development.python.enable = true;
  };

  # TODO refactor
  home-manager.users.${user} = {
    imports = [./dconf.nix];

    programs.home-manager.enable = true;
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        export TESTI=test
        export PROJECT_HOME=$HOME/Devel
      '';
    };

    programs.git = {
      enable = true;
      userName = "Georges";
      userEmail = "georges.alkhouri@gmail.com";
    };

    # # auto start libinput-gestures
    # home.file.".config/autostart/libinput-gestures.desktop".source = ''${pkgs.libinput-gestures}/share/applications/libinput-gestures.desktop'';
    # # see https://github.com/bulletmark/libinput-gestures/blob/master/libinput-gestures.conf
    # home.file.".config/libinput-gestures.conf".text = ''
    #   gesture swipe right 4	_internal ws_left
    #   gesture swipe left 4	_internal ws_right
    #   gesture swipe left 3	xdotool key alt+Left
    #   gesture swipe right 3 xdotool key alt+Right
    #   # gesture pinch in	xdotool key ctrl+F9
    #   # gesture pinch out	xdotool key ctrl+F9
    # '';
  };

  networking.interfaces.enp5s0.useDHCP = true;
  networking.networkmanager.enable = true;

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
  # programs.dconf.enable = true;

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
    gnomeExtensions.keyboard-backlight-slider
    virt-manager
    # vagrant
    vim
    gnumake
    signal-desktop
    element-desktop-wayland
    clinfo
    tealdeer
    powertop
    git
    gitflow
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

  environment.gnome.excludePackages = with pkgs; [
    gnome.epiphany
    gnome.gnome-music
    gnome.geary
    gnome-photos
    gnome-tour
  ];

  users.users.root.passwordFile =
    config.age.secrets."passwords/users/root".path;
  age.secrets."passwords/users/dev".file =
    ../../secrets/passwords/users/dev.age;
  age.secrets."passwords/users/root".file =
    ../../secrets/passwords/users/root.age;

  # TODO refactor
  age.identityPaths = ["/etc/dotfiles/id_ed25519"];

  programs.ssh.startAgent = true;
}
