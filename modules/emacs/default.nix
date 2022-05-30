
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
          cd "$EMACS" && make tangle
        fi
      '';
    };
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "02c4kmik140bbw85yvz82z82p19p0hv0hpn3dhv46g8i4kqjfqz0";
    }))
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    gentium-book-basic
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
    shellcheck
    hunspell
    hunspellDicts.en_US-large
    rnix-lsp
    emacs-all-the-icons-fonts
  ];              
}
