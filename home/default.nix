{ self, ... }:
{
  flake = {
    homeModules = {
      default = {
        imports = [
          # This loads ./home/neovim/default.nix - neovim configured for Haskell dev, and other things.
          ./neovim
          ./starship.nix
          ./terminal.nix
          # Add more of your home-manager modules here.
        ];
      };
    };
  };
}
