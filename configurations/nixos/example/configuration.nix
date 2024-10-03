{
  # These are normally in hardware-configuration.nix
  boot.loader.grub.device = "nodev";
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "btrfs"; };

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "example";

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  # users.users."runner".home = "/Users/runner";
  users.users."runner".isNormalUser = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "24.05";
}
