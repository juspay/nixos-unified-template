{ lib, ... }:
{
  options = {
    users = lib.mkOption {
      default = { };
      description = "All available users";
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
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
