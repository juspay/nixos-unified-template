# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, ... }:
{
  imports = [
    ../../users/module/system.nix
  ];
  services.openssh.enable = true;
}
