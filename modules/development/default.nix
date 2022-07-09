{ config, options, lib, pkgs, user, ... }:

with lib;
let cfg = config.modules.development;

in {
  options.modules.development.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {

    home-manager.users.${user} = {
      programs.bash = {
        bashrcExtra = ''
          eval "$(direnv hook bash)"
        '';
      };
    };
    services.lorri.enable = true;

    environment.systemPackages = with pkgs; [ direnv nixfmt ];
  };

}
