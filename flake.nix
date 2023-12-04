{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    # see https://github.com/nix-systems/default/blob/main/default.nix
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.nixos-flake.flakeModule
      ];

      flake.templates.default = {
        description = "A `home-manager` template providing useful tools & settings for Nix-based development";
        path = builtins.path {
          path = ./.;
          filter = path: _: with inputs.nixpkgs.lib;
            !(hasSuffix "LICENSE" path ||
              hasSuffix "README.md" path ||
              hasSuffix "flake.lock" path);
        };
      };

      perSystem = { self', pkgs, ... }:
        let
          # TODO: Change username
          myUserName = "runner";
        in
        {
          legacyPackages.homeConfigurations.${myUserName} =
            inputs.self.nixos-flake.lib.mkHomeConfiguration
              pkgs
              ({ pkgs, ... }: {
                # Edit the contents of the ./home directory to install packages and modify dotfile configuration in your
                # $HOME.
                #
                # https://nix-community.github.io/home-manager/index.html#sec-usage-configuration
                imports = [ ./home ];
                home.username = myUserName;
                home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${myUserName}";
                home.stateVersion = "22.11";
              });

          formatter = pkgs.nixpkgs-fmt;

          # Enables 'nix run' to activate.
          apps.default.program = self'.packages.activate-home;

          # Enable 'nix build' to build the home configuration, but without
          # activating.
          packages.default = self'.legacyPackages.homeConfigurations.${myUserName}.activationPackage;

          devShells.default = pkgs.mkShell {
            name = "nix-dev-home";
            nativeBuildInputs = with pkgs; [ just ];
          };
        };
    };
}
