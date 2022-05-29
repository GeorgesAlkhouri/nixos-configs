
{ config, pkgs, ... }:

{
  services.emacs.package = pkgs.emacsUnstable;

  system.userActivationScripts = {                    
    emacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        EMACS="$HOME/.emacs.d"
        if [ ! -d "$EMACS" ]; then
          git clone https://github.com/GeorgesAlkhouri/.emacs.d.git
        fi
        # make -f "$EMACS/Makefile" tangle
      '';
    };
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "1vcnfwki3g2a1m1z3czwzmg6wq120jiy3qa4vbri466q74gbw5id";
    }))
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    gentium-book-basic
  ];

  environment.systemPackages = with pkgs; [
    emacsNativeComp
    silver-searcher
    shellcheck
    hunspell
    hunspellDicts.en_US-large
    cmake
    libvterm
    libtool
    rnix-lsp
    emacs-all-the-icons-fonts
  ];              
}
