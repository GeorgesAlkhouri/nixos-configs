{ config, options, lib, pkgs, inputs, ... }:

with lib;
let cfg = config.modules.editors.emacs;

in {
  options.modules.editors.emacs.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    environment.systemPackages = with pkgs;
      [
        ## Emacs itself
        binutils # native-comp needs 'as', provided by this
        # 29 + native-comp
        ((emacsPackagesFor emacsNativeComp).emacsWithPackages
          (epkgs: [ epkgs.vterm ]))

        git
        gnutls # for tls
        # other dependencies
        ripgrep
        shellcheck
        hunspell
        hunspellDicts.en_US-large
        rnix-lsp # nix language-server
        emacs-all-the-icons-fonts
        nodePackages.yaml-language-server
      ] ++ [ pkgs.unstable.nodePackages.pyright ];

    fonts.fonts = with pkgs; [ jetbrains-mono gentium-book-basic ];

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
  };

}
