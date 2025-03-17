{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  me = import ./config.nix;
in
{
  imports = [
    self.homeModules.default
  ];

  home.username = me.username;
}
