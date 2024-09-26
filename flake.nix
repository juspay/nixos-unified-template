{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    systems.url = "github:nix-systems/default";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      # See ./nix/modules/flake-parts/*.nix for the modules that are imported here.
      imports = with builtins;
        map
          (fn: ./nix/modules/flake-parts/${fn})
          (attrNames (readDir ./nix/modules/flake-parts));

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          name = "nix-dev-home-shell";
          meta.description = "Shell environment for modifying this Nix configuration";
          packages = with pkgs; [
            just
            nixd
          ];
        };
      };
    };
}
