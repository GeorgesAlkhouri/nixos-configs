# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.
# Taken from
# https://github.com/hlissner/dotfiles/blob/master/modules/xdg.nix
{
  config,
  home-manager,
  user,
  ...
}: {
  ### A tidy $HOME is a tidy mind
  home-manager.users.${user}.xdg.enable = true;

  environment = {
    sessionVariables = {
      # These are the defaults, and xdg.enable does set them, but due to load
      # order, they're not set before environment.variables are set, which could
      # cause race conditions.
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
    variables = {
      # Conform more programs to XDG conventions. The rest are handled by their
      # respective modules.
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    };
  };

  system.userActivationScripts.createHistFileFolder = ''
    mkdir -p "$XDG_DATA_HOME/bash"
  '';
}
