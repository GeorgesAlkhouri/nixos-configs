{ pkgs, ... }:

{

  programs.bash = {
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };
}
