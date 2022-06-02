
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

  programs.firefox = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Devel 
    source virtualenvwrapper.sh
    '';
  };
  
}
