# Top-level flake glue to get our home-manager configuration working
{ self, inputs, lib, ... }:

{
  imports = [
    inputs.nixos-flake.flakeModule
  ];
  perSystem = { self', pkgs, ... }: {
    legacyPackages.homeConfigurations."runner" =
      inputs.self.nixos-flake.lib.mkHomeConfiguration
        pkgs
        ({ pkgs, ... }: {
          # Edit the contents of the nix/modules/home directory to install packages and modify dotfile configuration in your $HOME.
          #
          # https://nix-community.github.io/home-manager/index.xhtml#sec-usage-configuration
          imports = with builtins;
            map
              (fn: ../home/${fn})
              (attrNames (readDir ../home));
          home.username = "runner";
          home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/runner";
          home.stateVersion = "22.11";
        });

    # Enables 'nix run' to activate.
    apps.default = {
      inherit (self'.packages.activate) meta;
      program = pkgs.writeShellApplication {
        name = "activate";
        text = ''
          set -x
          ${lib.getExe self'.packages.activate} "runner"@;
        '';
      };
    };

    # Enable 'nix build' to build the home configuration, but without
    # activating.
    packages.default =
      let pkg = self'.legacyPackages.homeConfigurations."runner".activationPackage;
      in pkg.overrideAttrs (oldAttrs: {
        meta.description = "Built home configuration for user 'runner'";
      });


    # For 'nix fmt'
    formatter = pkgs.nixpkgs-fmt;
  };
}
