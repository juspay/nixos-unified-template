{ lib, ... }:
{
  options = {
    me = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
            default = "runner";
            description = "Your username as shown by `id -un`";
          };
          fullname = lib.mkOption {
            type = lib.types.str;
            default = "John Doe";
            description = "Your full name for use in Git config";
          };
          email = lib.mkOption {
            type = lib.types.str;
            default = "johndoe@example.com";
            description = "Your email for use in Git config";
          };
        };
      };
    };
  };
}
