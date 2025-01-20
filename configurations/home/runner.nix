{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];
  # To use the `nix` from `inputs.nixpkgs` on templates using the standalone `home-manager` template
  home.packages = [
    config.nix.package
  ];
  home.username = "runner";
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/runner";
  home.stateVersion = "24.11";
}
