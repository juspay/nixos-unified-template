# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake.templates.default = {
    description = "A `home-manager` template providing useful tools & settings for Nix-based development";
    path = builtins.path {
      path = ./.;
      filter = path: _: with inputs.nixpkgs.lib;
        !(hasSuffix "LICENSE" path ||
          hasSuffix "README.md" path ||
          hasSuffix "flake.lock" path);
    };
  };
}
