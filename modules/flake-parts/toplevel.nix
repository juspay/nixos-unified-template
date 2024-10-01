# Top-level flake glue to get our configuration working
{ inputs, ... }:

{
  imports = [
    inputs.nixos-flake.flakeModules.default
    inputs.nixos-flake.flakeModules.autoWire
  ];
  perSystem = { self', pkgs, ... }: {
    # For 'nix fmt'
    formatter = pkgs.nixpkgs-fmt;

    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate;
  };
}
