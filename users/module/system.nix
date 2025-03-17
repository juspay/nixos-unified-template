{ flake, config, pkgs, lib, ... }:
{
  options = {
    myusers = lib.mkOption {
      type = lib.types.lazyAttrsOf
        (lib.types.submodule {
          imports = [ ./user.nix ];
        });
      default = {
        runner = import ../runner.nix;
      };
    };
  };
  config = {
    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = lib.mapAttrs
      (_: v: lib.optionalAttrs pkgs.stdenv.isDarwin
        {
          home = "/Users/${v.me.username}";
        } // lib.optionalAttrs pkgs.stdenv.isLinux {
        isNormalUser = true;
      })
      config.myusers;

    # Enable home-manager for our user
    home-manager.users = lib.mapAttrs
      (_: v: {
        imports = [ (flake.self + /configurations/home/${v.me.username}) ];
      })
      config.myusers;
  };
}
