# List of users for darwin or nixos system and their top-level configuration.
{ flake, pkgs, lib, config, ... }:
let
  inherit (flake.inputs) self;
  mapListToAttrs = m: f:
    lib.listToAttrs (map (name: { inherit name; value = f name; }) m);

  # Collect all extraGroups per user (defined inside home-manager configs)
  userGroups =
    builtins.listToAttrs (map (userName: {
      name = userName;
      value = (config.home-manager.users.${userName}.me.extraGroups or []);
    }) config.myusers);

  # Build group → members mapping (Darwin replacement for extraGroups)
  groupMembers =
    lib.flip lib.foldl' {} (builtins.attrNames userGroups) (acc: userName:
      let groups = userGroups.${userName};
      in lib.foldl' (acc2: g: acc2 // { ${g} = (acc2.${g} or []) ++ [ userName ]; })
         acc
         groups
    );
in
{
  options = {
    myusers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of usernames";
      defaultText = "All users under ./configuration/users are included by default";
      default =
        let
          dirContents = builtins.readDir (self + /configurations/home);
          fileNames = builtins.attrNames dirContents; # Extracts keys: [ "runner.nix" ]
          regularFiles = builtins.filter (name: dirContents.${name} == "regular") fileNames; # Filters for regular files
          baseNames = map (name: builtins.replaceStrings [ ".nix" ] [ "" ] name) regularFiles; # Removes .nix extension
        in
        baseNames;
    };
  };

  config = {
    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = mapListToAttrs config.myusers (name:
      let
        userConfig = config.home-manager.users.${name};
      in
      lib.optionalAttrs pkgs.stdenv.isDarwin
        {
          home = "/Users/${name}";
        } // lib.optionalAttrs pkgs.stdenv.isLinux {
        isNormalUser = true;
        extraGroups = userConfig.me.extraGroups;
      }
    );

    # Darwin does not support users.users.<name>.extraGroups directly.
    # Instead, we reconstruct groups → members here so that extraGroups
    # defined in home-manager configs still apply on macOS.
    users.groups = lib.optionalAttrs pkgs.stdenv.isDarwin (
      lib.mapAttrs (groupName: members: {
        members = lib.unique members;
      }) groupMembers
    );

    # Enable home-manager for our user
    home-manager.users = mapListToAttrs config.myusers (name: {
      imports = [ (self + /configurations/home/${name}.nix) ];
    });

    # All users can add Nix caches.
    nix.settings.trusted-users = [
      "root"
    ] ++ config.myusers;
  };
}
