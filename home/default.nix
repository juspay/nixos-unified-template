{ flake, ... }:
{
  imports = [
    ./terminal.nix
    ./starship.nix
    ./neovim.nix
    # Add more of your home-manager modules here.
  ];

  # Recommended Nix settings
  nix = {
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  };
}
