{ lib, ... }:
{
  options = {
    users = lib.mkOption {
      default = { };
      description = "All available users";
      type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
        options = {
          configuration.home = lib.mkOption {
            type = lib.types.deferredModule;
            description = "Home configuration for the user";
          };
          configuration.darwin = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.raw;
            description = "Darwin configuration for the user";
            readOnly = true;
            default = {
              # For home-manager to work.
              # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
              home = "/Users/${config.username}";
            };
          };
          configuration.nixos = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.raw;
            description = "NixOS configuration for the user";
            readOnly = true;
            default = {
              # For home-manager to work.
              # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
              isNormalUser = true;
            };
          };
          username = lib.mkOption {
            type = lib.types.str;
            description = "Your username as shown by `id -un`";
            default = name;
            defaultText = "By default, this is the attrset key.";
          };
          fullname = lib.mkOption {
            type = lib.types.str;
            description = "Your full name for use in Git config";
          };
          email = lib.mkOption {
            type = lib.types.str;
            description = "Your email for use in Git config";
          };
        };
      }));
    };
  };
}
