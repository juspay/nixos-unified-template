# Per-user configuration spec.
{ lib, ... }:
{
  options = {
    me = {
      configuration.home = lib.mkOption {
        type = lib.types.deferredModule;
        description = "Home configuration for the user";
      };
      username = lib.mkOption {
        type = lib.types.str;
        description = "Your username as shown by `id -un`";
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
  };
}
