{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  me = {
    username = "runner";
    fullname = "John Doe";
    email = "johndoe@example.com";
  };

  home.stateVersion = "24.11";
}
