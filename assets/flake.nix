{
  description = "nixos-unified-template flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = { system, ... }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              # Packages used to take demo
              vhs
              ffmpeg
              ttyd
              chromium

              # Packages used within demo
              tree
              # xclip
              # wl-clipboard
            ];
          };
        };
    };
}
