{ flake, ... }:
{
  imports = [
    flake.inputs.nix-index-database.hmModules.nix-index
  ];

  # command-not-found handler to suggest nix way of installing stuff.
  # FIXME: This ought to show new nix cli commands though:
  # https://github.com/nix-community/nix-index/issues/191
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  # nix-index-database.comma.enable = true;

}
