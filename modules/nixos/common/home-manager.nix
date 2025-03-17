# Enable home-manager for all users
{ flake, pkgs, lib, ... }:

{
  users.users = lib.mapAttrs
    (_: v:
      if pkgs.stdenv.isDarwin
      then v.configuration.darwin
      else v.configuration.nixos)
    flake.config.users;

  # Enable home-manager for our user
  home-manager.users = lib.mapAttrs
    (_: v: v.configuration.home)
    flake.config.users;
}
