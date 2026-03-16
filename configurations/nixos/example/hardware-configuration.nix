# This file pertains to the use of disko & disko-install.
#
# If you did manual NixOS install, you may want to replace this with your /etc/nixos/hardware-configuration.nix
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
}
