# Neovim configuration managed using https://github.com/nix-community/nixvim
{ flake, ... }: {
  imports = [ flake.inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = import ./../../pkgs/neovim.nix // { enable = true; };

}
