{ config, pkgs, lib, ... }:
{
  imports = [
    ../../users/module/home.nix
  ];
  home.stateVersion = "24.11";
}
