# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.gui
    ./configuration.nix
  ];

  # Enable home-manager for "runner" user
  home-manager.users."runner" = {
    imports = [ (self + /configurations/home/runner.nix) ];
  };
}
