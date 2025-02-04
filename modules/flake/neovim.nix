{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }:
    let
      neovimWithConfig = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../home/neovim/nixvim.nix;
      };
    in
    {
      packages.neovim = neovimWithConfig.overrideAttrs (oa: {
        meta = oa.meta // {
          description = "Neovim with NixVim configuration";
        };
      });
    };
}
