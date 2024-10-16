# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" "runner" ];

  services.openssh.enable = true;
}
