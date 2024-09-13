{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages.neovim =
      inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../home/neovim/nixvim.nix;
      };
  };
}
