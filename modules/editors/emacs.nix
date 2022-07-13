{ config, options, lib, pkgs, inputs, ... }:

with lib;
let cfg = config.modules.editors.emacs;

in {
  options.modules.editors.emacs.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    environment.systemPackages = with pkgs;
      [
        ## Emacs itself
        binutils # native-comp needs 'as', provided by this
        # 29 + native-comp
        # TODO: make configurable if pgtk or not
        ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages
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
          if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
            git clone https://github.com/GeorgesAlkhouri/.emacs.d.git $XDG_CONFIG_HOME/emacs
            cd "$XDG_CONFIG_HOME/emacs" && make tangle
          fi
        '';
      };
    };
  };

}
