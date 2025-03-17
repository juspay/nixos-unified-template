{ flake, ... }:
let
  inherit (flake.inputs) self;
in
{
  imports = [
    ./config.nix
    self.homeModules.default
  ];
}
