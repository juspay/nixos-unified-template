# NOTE: We expect this file to be supplanted by the original /etc/nixos/configuration.nix
{
  # These are normally in hardware-configuration.nix
  boot.loader.grub.device = "nodev";
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "btrfs"; };

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "example";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "24.11";
}
