# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, lib, ... }:

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

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users = lib.mapAttrs
    (_: _: {
      isNormalUser = true;
    })
    flake.config.users;

  # Enable home-manager for our user
  home-manager.users = lib.mapAttrs
    (_: v: {
      imports = [ (self + /configurations/home/${v.username}.nix) ];
    })
    flake.config.users;
}
