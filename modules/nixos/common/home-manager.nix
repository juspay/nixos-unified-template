# Enable home-manager for all users
{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users = lib.mapAttrs
    (_: v: lib.optionalAttrs pkgs.stdenv.isDarwin {
      home = "/Users/${v.username}";
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      isNormalUser = true;
    })
    flake.config.users;

  # Enable home-manager for our user
  home-manager.users = lib.mapAttrs
    (_: v: {
      imports = [ (self + /configurations/home/${v.username}) ];
    })
    flake.config.users;
}
