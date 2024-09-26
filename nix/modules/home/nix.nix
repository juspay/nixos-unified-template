{ config, flake, pkgs, ... }:
{
  # Make Nix and home-manager installed things available in PATH.
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/etc/profiles/per-user/$USER/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin/"
  ];

  # Recommended Nix settings
  nix = {
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc

    # Garbage collect the Nix store
    gc = {
      automatic = true;
      # Change how often the garbage collector runs (default: weekly)
      # frequency = "monthly";
    };
  };

  # nixpkgs settings
  nixpkgs = {
    overlays = [
      # Add a package to nixpkgs
      (final: prev: { })
    ];
  };
}
