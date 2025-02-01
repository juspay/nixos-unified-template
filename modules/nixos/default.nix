# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  inherit (flake.config) me;
in
{
  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" me.username ];

  services.openssh.enable = true;
}
