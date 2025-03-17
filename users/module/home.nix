# The home-manager module defining per-user configuration and implementation
{ config, pkgs, lib, ... }:
{
  imports = [
    ./user.nix
  ];
  config = {
    home.username = config.me.username;
    home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${config.me.username}";
  };
}
