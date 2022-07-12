{ config, lib, pkgs, user, ... }:

{

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "22.05";

  home.packages = [ pkgs.git pkgs.gitflow ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Georges";
    userEmail = "georges.alkhouri@gmail.com";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PROJECT_HOME=$HOME/Devel 
    '';
  };

  dconf.settings = {
    "org/gnome/shell"."enabled-extensions" = [ "hibernate-status@dromi" ];
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
}
