{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nix-dev-home-shell";
      meta.description = "Shell environment for modifying this Nix configuration";
      packages = with pkgs; [
        just
        nixd
      ];
    };
  };
}
