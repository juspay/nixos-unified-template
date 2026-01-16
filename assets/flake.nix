{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }: let
          app = pkgs.writeShellApplication {
            name = "demo";
            runtimeInputs = with pkgs; [
              nix
              omnix
              vhs
              eza
              nerd-fonts.jetbrains-mono
            ];
            text = ''
              nix flake prefetch github:juspay/nixos-unified-template
              nix build nixpkgs#omnix --no-link
              nix build nixpkgs#vhs --no-link
              nix build nixpkgs#eza --no-link
              nix build nixpkgs#nerd-fonts.jetbrains-mono --no-link
              vhs ./demo.tape
              rm -rf ./nixconfig
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
