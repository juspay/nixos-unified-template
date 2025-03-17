# The home-manager module defining per-user configuration and implementation
{ config, ... }:
{
  imports = [
    ./user.nix
  ];
  config = {
    home.username = config.me.username;
  };
}
