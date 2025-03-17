{ config, pkgs, lib, ... }:
{
  imports = [
    ../../users/module/home.nix
  ];
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${config.home.username}";
  home.stateVersion = "24.11";
}
