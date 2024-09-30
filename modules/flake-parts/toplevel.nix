# Top-level flake glue to get our home-manager configuration working
{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-flake.flakeModule
  ];
  perSystem = { self', pkgs, ... }: {
    legacyPackages.homeConfigurations."runner" =
      inputs.self.nixos-flake.lib.mkHomeConfiguration
        pkgs
        ({ pkgs, ... }: {
          imports = [
            (inputs.self + /modules/home)
          ];
          home.username = "runner";
          home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/runner";
          home.stateVersion = "22.11";
        });

    # Enables 'nix run' to activate.
    apps.default = {
      inherit (self'.packages.activate) meta;
      program = pkgs.writeShellApplication {
        name = "activate-home";
        text = ''
          set -x
          ${lib.getExe self'.packages.activate} "$USER"@
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
