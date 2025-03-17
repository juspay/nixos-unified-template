# Configuration common to NixOS and darwin
{
  imports = [
    ./trust-everyone.nix
    ./home-manager.nix
  ];
}
