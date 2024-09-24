{ config, flake, pkgs, ... }:
{
  # Install stable version of Nix in PATH
  home.packages = [ config.nix.package ];

  # Recommended Nix settings
  nix = {
    # Which Nix version to use
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix
    #
    # We use latest, to be in sync with what DetSys installs (and for compatibility with the nix.conf it generates globally)
    package = pkgs.nixVersions.latest;

    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc

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
