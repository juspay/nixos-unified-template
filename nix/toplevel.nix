# Top-level flake glue to get our home-manager configuration working
{ self, inputs, lib, ... }:

{
  flake = {
    # cf. https://nixos.asia/en/nix-modules
    options = {
      nix-dev-home.username = lib.mkOption {
        type = lib.types.str;
        description = "The username to use for the home-manager configuration";
      };
    };
  };
  perSystem = { self', pkgs, ... }: {
    legacyPackages.homeConfigurations.${self.nix-dev-home.username} =
      inputs.self.nixos-flake.lib.mkHomeConfiguration
        pkgs
        ({ pkgs, ... }: {
          # Edit the contents of the ./home directory to install packages and modify dotfile configuration in your
          # $HOME.
          #
          # https://nix-community.github.io/home-manager/index.html#sec-usage-configuration
          imports = [ ../home ];
          home.username = self.nix-dev-home.username;
          home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${self.nix-dev-home.username}";
          home.stateVersion = "22.11";
        });

    # Enables 'nix run' to activate.
    apps.default.program = self'.packages.activate-home;

    # Enable 'nix build' to build the home configuration, but without
    # activating.
    packages.default = self'.legacyPackages.homeConfigurations.${self.nix-dev-home.username}.activationPackage;
  };
}
