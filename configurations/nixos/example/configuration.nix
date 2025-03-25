# NOTE: We expect this file to be supplanted by the original /etc/nixos/configuration.nix
{ flake, ... }:
{
  imports = [
    flake.inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "example";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "24.11";
}
