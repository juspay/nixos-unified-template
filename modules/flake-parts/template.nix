# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake = rec {
    templates =
      let
        mkDescription = name:
          "A ${name} template providing useful tools & settings for Nix-based development";

        filters = path: with inputs.nixpkgs.lib; {
          homeOnly =
            hasPrefix "configurations/home" path
            || hasSuffix "activate-home.nix" path;
          darwinOnly =
            hasPrefix "configurations/darwin" path
            || hasPrefix "modules/darwin" path;
          alwaysExclude =
            hasSuffix "LICENSE" path
            || hasSuffix "README.md" path
            || hasSuffix ".github/" path
            || hasSuffix "template.nix" path
            || hasSuffix "test.nix" path
          ;
        };
      in
      {
        default = {
          description = mkDescription "nix-darwin/home-manager";

          path = builtins.path {
            path = inputs.self;
            filter = path: _:
              !(filters path).alwaysExclude;
          };
        };

        home = let parent = templates.default; in {
          description = mkDescription "home-manager";
          welcomeText = ''
            You have just created a nix-dev-home flake.nix using home-manager.

            - Edit `./modules/home/*.nix` to customize your configuration.
            - Run `nix run` to apply the configuration.
            - Then, open a new terminal to see your new shell.

            Enjoy!
          '';
          path = builtins.path {
            path = parent.path;
            filter = path: _:
              !(filters path).darwinOnly;
          };
        };

        nix-darwin = let parent = templates.default; in {
          description = mkDescription "nix-darwin";
          welcomeText = ''
            You have just created a nix-dev-home flake.nix using nix-darwin / home-manager.

            - Edit `./modules/{home,darwin}/*.nix` to customize your configuration.

            Then, as first-time activation, run:

            ```
            sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
            nix --extra-experimental-features "nix-command flakes" run
            ```

            Then, open a new terminal to see your new shell.

            Thereon, you can simply `nix run` whenever changing your configuration.

            Enjoy!
          '';
          path = builtins.path {
            path = parent.path;
            filter = path: _:
              !(filters path).homeOnly;
          };
        };
      };

    # https://omnix.page/om/init.html#spec
    om.templates = {
      home = {
        template = templates.home;
        params = [
          {
            name = "username";
            description = "Your username as shown by `whoami`";
            placeholder = "runner";
          }
          # Git
          {
            name = "git-name";
            description = "Your full name for use in Git config";
            placeholder = "John Doe";
          }
          {
            name = "git-email";
            description = "Your email for use in Git config";
            placeholder = "johndoe@example.com";
          }
          # Neovim
          {
            name = "neovim";
            description = "Include Neovim configuration";
            paths = [ "**/neovim**" ];
            value = false;
          }
        ];
      };

      darwin = {
        template = templates.nix-darwin;
        params = [
          {
            name = "hostname";
            description = "Your system hostname as shown by `hostname -s`";
            placeholder = "example";
          }
        ] ++ om.templates.home.params;
      };
    };
  };
}
