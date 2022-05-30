
{ config, lib, pkgs, user, ... }:

{
  home.username = user;
  home.homeDirectory = "/home/${user}";

}
