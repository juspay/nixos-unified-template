{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, ... }: let
          fontsConf = pkgs.makeFontsConf {
            fontDirectories = [
              pkgs.nerd-fonts.jetbrains-mono
            ];
          };
          app = pkgs.writeShellApplication {
            name = "demo";
            runtimeInputs = with pkgs; [
              omnix
              vhs
              eza
              fish
              fontconfig
            ];
            text = ''
              export FONTCONFIG_FILE=${fontsConf}
              nix flake prefetch github:juspay/nixos-unified-template
              vhs ./demo.tape || true && rm -rf ./nixconfig
            '';
          };
        in
        {
          apps.default = {
            program = "${app}/bin/demo";
          };
        };
    };
}
