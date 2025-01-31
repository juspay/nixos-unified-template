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
          };
          fullname = lib.mkOption {
            type = lib.types.str;
            default = "John Doe";
          };
          email = lib.mkOption {
            type = lib.types.str;
            default = "johndoe@example.com";
          };
        };
      };
    };
  };
}
