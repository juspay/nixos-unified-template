# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake.templates.default = {
    description = "A `home-manager` template providing useful tools & settings for Nix-based development";
    welcomeText = ''
      You have just created a home-manager flake.nix.

      - Edit `nix/modules/home/*.nix` to customize your home-manager configuration.
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
}
