{ flake, ... }:
{
  imports = [
    flake.inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = import ./nixvim.nix // {
    enable = true;
  };
}
