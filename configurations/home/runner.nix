{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  me = flake.config.users."runner";
in
{
  imports = [
    self.homeModules.default
  ];

  home.username = me.username;
  home.stateVersion = "24.11";
}
