# Top-level flake glue to get our home-manager configuration working
{ inputs, ... }:

{
  perSystem = { self', pkgs, ... }:
    let
      inherit (import ../config.nix) myUserName;
    in
    {
      legacyPackages.homeConfigurations.${myUserName} =
        inputs.self.nixos-flake.lib.mkHomeConfiguration
          pkgs
          ({ pkgs, ... }: {
            # Edit the contents of the ./home directory to install packages and modify dotfile configuration in your
            # $HOME.
            #
            # https://nix-community.github.io/home-manager/index.html#sec-usage-configuration
            imports = [ ../home.nix ];
            home.username = myUserName;
            home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${myUserName}";
            home.stateVersion = "22.11";
          });

      # Enables 'nix run' to activate.
      apps.default.program = self'.packages.activate-home;

      # Enable 'nix build' to build the home configuration, but without
      # activating.
      packages.default = self'.legacyPackages.homeConfigurations.${myUserName}.activationPackage;
    };
}
