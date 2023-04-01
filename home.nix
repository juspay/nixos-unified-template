# Edit this to install packages and modify dotfile configuration in your
# $HOME.
#
# https://nix-community.github.io/home-manager/index.html#sec-usage-configuration
{ pkgs, ... }: {
  imports = [
    # Add your other home-manager modules here.
  ];

  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    nix-output-monitor # https://github.com/maralorn/nix-output-monitor
    nix-info
  ];

  # Programs natively supported by home-manager.
  programs = {
    bash.enable = true;

    # For macOS's default shell.
    zsh.enable = true;

    # https://haskell.flake.page/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    starship.enable = true;
  };
}
