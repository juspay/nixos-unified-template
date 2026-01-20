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
            runtimeEnv = {
              output_dir = "nixconfig";
              FONTCONFIG_FILE = "${fontsConf}";
            };
            runtimeInputs = with pkgs; [
              omnix
              vhs
              eza
              fish
              fontconfig
            ];
            text = ''
              nix flake prefetch github:juspay/nixos-unified-template
              vhs ./demo.tape; rm -rf ./$output_dir
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
