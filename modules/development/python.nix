{ config, options, lib, pkgs, inputs, ... }:

with lib;
let
  inherit (inputs) mach-nix;
  cfg = config.modules.development.python;

in
{
  options.modules.development.python.enable = mkOption {
    type = types.bool;
    default = false;
  };


  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ mach-nix.defaultPackage.x86_64-linux ];
  };

}
