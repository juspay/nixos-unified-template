{ config, flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  me = import ./config.nix;
in
{
  imports = [
    self.homeModules.default
  ];

  home.username = me.username;
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${config.home.username}";
  home.stateVersion = "24.11";
}
