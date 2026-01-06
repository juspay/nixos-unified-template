{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
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
              ttyd
              ffmpeg
              chromium
              nerd-fonts.jetbrains-mono
            ];
            text = ''
              nix flake prefetch-inputs .
              nix flake prefetch github:juspay/nixos-unified-template
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
