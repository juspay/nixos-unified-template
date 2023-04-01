{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake.homeModules.default = ./home.nix;

      flake.templates.default = {
        description = "A `home-manager` template providing useful tools & settings for Nix-based development";
        path = builtins.path {
          path = ./.;
          filter = path: _:
            inputs.nixpkgs.lib.hasSuffix ".nix" path ||
            inputs.nixpkgs.lib.hasSuffix ".lock" path;
        };
      };

      perSystem = { self', pkgs, ... }:
        let
          # TODO: Change username
          myUserName = "john";
        in
        {
          legacyPackages.homeConfigurations.${myUserName} =
            self.nixos-flake.lib.mkHomeConfiguration
              pkgs
              ({ pkgs, ... }: {
                imports = [ self.homeModules.default ];
                home.username = myUserName;
                home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${myUserName}";
                home.stateVersion = "22.11";
              });

          # Enables 'nix run' to activate.
          apps.default.program = self'.packages.activate-home;

          # Enable 'nix build' to build the home configuration, but without
          # activating.
          packages.default = self'.legacyPackages.homeConfigurations.${myUserName}.activationPackage;
        };
    };
}
