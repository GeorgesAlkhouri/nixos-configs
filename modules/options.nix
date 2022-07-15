# user.nix
# add base config for a user
# taken from https://github.com/hlissner/dotfiles/blob/master/modules/options.nix
{
  config,
  options,
  lib,
  user,
  ...
}:
with lib; {
  options = with types; {
    home = {
      file = mkOption {
        type = attrs;
        default = {};
        description = "Files to place directly in $HOME";
      };

      configFile = mkOption {
        type = attrs;
        default = {};
        description = "Files to place directly in $XDG_CONFIG_HOME";
      };

      dataFile = mkOption {
        type = attrs;
        default = {};
        description = "Files to place directly in $XDG_DATA_HOME";
      };
    };
  };

  config = {
    home-manager = {
      useUserPackages = true;
      users.${user} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };
  };
}
