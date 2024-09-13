{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.neovim =
      inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        inherit pkgs;
        module = import ../home/neovim/nixvim.nix;
      };
  };
}
