# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake.templates.default = {
    description = "A `home-manager` template providing useful tools & settings for Nix-based development";
    welcomeText = ''
      You have just created a home-manager flake.nix.

      - Edit `home/modules/home/*.nix` to customize your home-manager configuration.
      - Run `nix run` to apply the configuration.

      Enjoy!
    '';
    path = builtins.path {
      path = inputs.self;
      filter = path: _: with inputs.nixpkgs.lib;
        !(hasSuffix "LICENSE" path ||
          hasSuffix "README.md" path ||
          hasSuffix ".github/" path);
    };
  };

  perSystem = { pkgs, ... }: {
    # Used to replace username in flake.nix (see README.md)
    #
    # This is better than `nix run nixpkgs#sd` which will fetch the latest
    # nixpkgs, not the one pinned in flake.nix.
    packages.sd = pkgs.sd;
  };
}
