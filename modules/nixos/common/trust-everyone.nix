{ flake, lib, ... }:

{
  # All users can add Nix caches.
  nix.settings.trusted-users = [
    "root"
  ] ++ lib.mapAttrsToList (_: v: v.username) flake.config.users;
}
