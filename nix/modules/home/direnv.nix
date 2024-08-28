{ config, pkgs, ... }:
{
  # https://nixos.asia/en/direnv
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      # Remove after https://github.com/juspay/nix-dev-home/issues/68
      package = pkgs.nix-direnv.override { nix = config.nix.package; };
    };
    config.global = {
      # Make direnv messages less verbose
      hide_env_diff = true;
    };
  };
}
