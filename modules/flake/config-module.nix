{ config, lib, ... }:
{
  options = {
    usersModule = lib.mkOption {
      readOnly = true;
      description = "The NixOS and nix-darwin module for setting up all users";
      type = lib.types.deferredModule;
      default = {
        imports = lib.mapAttrsToList (_: v: v.configuration.system) config.users;
      };
    };
    users = lib.mkOption {
      default = { };
      description = "All available users";
      type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
        options = {
          configuration.home = lib.mkOption {
            type = lib.types.deferredModule;
            description = "Home configuration for the user";
          };
          configuration.system = lib.mkOption {
            type = lib.types.deferredModule;
            description = "NixOS or nix-darwin configuration for the user";
            readOnly = true;
            default = { pkgs, ... }: {
              # For home-manager to work.
              # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
              users.users.${config.username} =
                if pkgs.stdenv.isDarwin
                then { home = "/Users/${config.username}"; }
                else { isNormalUser = true; };

              # Enable home-manager for our user
              home-manager.users.${config.username} = config.configuration.home;

              # All users can add Nix caches.
              nix.settings.trusted-users = [ config.username ];
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
