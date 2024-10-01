# Top-level flake glue to get our home-manager configuration working
{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-flake.flakeModules.default
    inputs.nixos-flake.flakeModules.autoWire
  ];
  perSystem = { self', pkgs, ... }: {
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

    # Run activation test
    # FIXME: This is failing on darwin; https://github.com/nix-community/home-manager/issues/4413
    apps.test = {
      meta.description = "Test home configuration activation by running for dummy user and home";
      program = pkgs.writeShellApplication {
        name = "test-home-activation";
        runtimeInputs = with pkgs; [
          git
          findutils
          gnugrep
        ];
        text = ''
          set -x
          # Override the home directory to a temp location
          echo '{ home.homeDirectory = "/tmp/runner"; }' > modules/home/test.nix
          WORKDIR=$(pwd)
          git add modules/home/test.nix
          trap 'git -C $WORKDIR rm -f modules/home/test.nix' EXIT

          # Activate on a temp location
          rm -rf /tmp/runner
          USER=runner HOME=/tmp/runner \
            nix run .#activate 'runner@'

          # List the intresting contents of the activated home
          find -L /tmp/runner/ | \
            grep -v \.cache | grep -v /share/ | grep -v /lib/ | grep -v /libexec/ | grep -v /.local/state

          # Run some tests
          cd /tmp/runner
          test -f .nix-profile/bin/git
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
