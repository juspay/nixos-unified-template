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
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      systems = import inputs.systems;
      imports = [
        inputs.nixos-flake.flakeModule
        # Edit the contenst of the ./home directory to install packages and modify dotfile configuration in your
        # $HOME.
        #
        # https://nix-community.github.io/home-manager/index.html#sec-usage-configuration
        ./home
      ];

      flake.templates.default = {
        description = "A `home-manager` template providing useful tools & settings for Nix-based development";
        path = builtins.path {
          path = ./.;
          filter = path: _:
            !(inputs.nixpkgs.lib.hasSuffix "LICENSE" path ||
              inputs.nixpkgs.lib.hasSuffix "README.md" path);
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
                imports = [ inputs.self.homeModules.default ];
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
        };
    };
}
