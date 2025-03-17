{ flake, ... }:
let
  inherit (flake.inputs) self;
in
{
  imports = [
    (self + /users/module/home.nix)
    (self + /users/runner.nix)
    flake.inputs.self.homeModules.default
  ];
}
