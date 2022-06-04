
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
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      rev = "06da47152be5f7d8186d2602ced50109ad77e519";
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
