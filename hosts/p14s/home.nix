
{ config, lib, pkgs, user, ... }:

{

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "22.05";

  home.packages = [
    pkgs.git
    pkgs.gitflow
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Georges";
    userEmail = "georges.alkhouri@gmail.com";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Devel 
    source virtualenvwrapper.sh
    '';
  };
  
  # auto start libinput-gestures
  home.file.".config/autostart/libinput-gestures.desktop".source = ''${pkgs.libinput-gestures}/share/applications/libinput-gestures.desktop'';
  # see https://github.com/bulletmark/libinput-gestures/blob/master/libinput-gestures.conf
  home.file.".config/libinput-gestures.conf".text = ''
   # gesture swipe up _internal ws_up
   gesture swipe left 3	xdotool key alt+Right
   gesture swipe right 3 xdotool key alt+Left
  '';                                            
}
