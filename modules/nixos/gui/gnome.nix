{ pkgs, ... }:
{
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.gnome-tweaks
  ];
}
