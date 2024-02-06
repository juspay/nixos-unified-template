{ flake, ... }:
{
  imports = [
    # This loads ./neovim/default.nix - neovim configured for Haskell dev, and other things.
    ./neovim
    ./starship.nix
    ./terminal.nix
    # Add more of your home-manager modules here.
  ];

  # Recommended Nix settings
  nix = {
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/
    # Garbage collect automatically every week
    gc.automatic = true;

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  };
}
