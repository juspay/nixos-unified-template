{ flake, ... }:
{
  imports = [
    flake.inputs.self.homeModules.default
  ];
  home.username = (import ./config.nix).username;
}
