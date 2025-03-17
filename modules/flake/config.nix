# Global configuration for this repo
#
# See ./modules/flake/config-module.nix for schema
{ self, ... }:
{
  # Users to enable on NixOS nix-darwin configurations.
  users = {
    runner = import (self + /configurations/home/runner/config.nix);
  };
}
