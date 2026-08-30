# User configuration module
{ config, lib, ... }:
{
  options = {
    me = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Your username as shown by `id -un`";
      };
      fullname = lib.mkOption {
        type = lib.types.str;
        description = "Your full name for use in Git config";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Your email for use in Git config";
      };
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra groups to which the user should belong. This is only used in NixOS/nix-darwin, and wouldn't work with standalone home-manager.";
        example = "[ \"wheel\" \"docker\" ]";
      };
    };
  };
  config = {
    home.username = config.me.username;
  };
}
