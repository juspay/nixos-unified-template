# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, lib, ... }:

{
  # These users can add Nix caches.
  nix.settings.trusted-users = [
    "root"
  ] ++ lib.mapAttrsToList (_: v: v.username) flake.config.users;

  services.openssh.enable = true;
}
