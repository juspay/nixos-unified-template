# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, ... }:
{
  imports = [
    flake.config.usersModule
  ];
  services.openssh.enable = true;
}
