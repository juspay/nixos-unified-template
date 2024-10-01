{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    (inputs.self + /modules/home)
  ];
  home.username = "runner";
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/runner";
  home.stateVersion = "22.11";
}
