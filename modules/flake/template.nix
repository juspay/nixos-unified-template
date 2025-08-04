# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake = rec {
    templates =
      let
        mkDescription = name:
          "A ${name} template providing useful tools & settings for Nix-based development";

        filters = path: with inputs.nixpkgs.lib; rec {
          homeOnly =
            # NOTE: configurations/home/* is imported in nix-darwin and NixOS
            hasSuffix "activate-home.nix" path;
          darwinOnly =
            hasInfix "configurations/darwin" path
            || hasInfix "modules/darwin" path;
          nixosOnly =
            hasInfix "configurations/nixos" path
            || (hasInfix "modules/nixos/" path && !hasInfix "modules/nixos/common" path);
          homeFilter =
              !(nixosOnly || darwinOnly) &&
              !hasInfix "modules/nixos" path;
          alwaysExclude =
            hasSuffix "LICENSE" path
            || hasSuffix "README.md" path
            || hasInfix ".github" path
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
            You have just created a nixos-unified-template flake.nix using home-manager.

            - Edit `./modules/home/*.nix` to customize your configuration.
            - Run `nix run` to apply the configuration.
            - Then, open a new terminal to see your new shell.

            Enjoy!
          '';
          path = builtins.path {
            path = parent.path;
            filter = path: _:
              let f = filters path;
              in
                f.homeFilter;
          };
        };

        nixos = let parent = templates.default; in {
          description = mkDescription "NixOS";
          welcomeText = ''
            You have just created a nixos-unified-template flake.nix using NixOS.

            - Edit `./modules/nixos/*.nix` to customize your configuration.
            - Run `mv /etc/nixos/*.nix ./configurations/nixos/HOSTNAME/` to import your existing configuration.
            - Run `nix --extra-experimental-features "nix-command flakes" run` to apply the configuration.

            Enjoy!
          '';
          path = builtins.path {
            path = parent.path;
            filter = path: _:
              let f = filters path;
              in
                !(f.darwinOnly || f.homeOnly);
          };
        };

        nix-darwin = let parent = templates.default; in {
          description = mkDescription "nix-darwin";
          welcomeText = ''
            You have just created a nixos-unified-template flake.nix using nix-darwin / home-manager.

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
              let f = filters path;
              in
                !(f.nixosOnly || f.homeOnly);
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
            description = "Your username as shown by `id -un`";
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
          # Work
          {
            name = "work";
            description = "Include work-related configuration (select only if a Juspay engineer)";
            paths = [ "**/work.nix" ];
            value = false;
          }
        ];
        tests = {
          default = {
            params = {
              username = "john";
              git-email = "john@ex.com";
              git-name = "John Doe";
              neovim = true;
            };
            asserts = {
              source = {
                "modules/home/neovim/default.nix" = true;
                ".github/workflows" = false;
              };
              packages."homeConfigurations.john.activationPackage" = {
                "home-path/bin/nvim" = true;
                "home-path/bin/git" = true;
                "home-path/bin/om" = true;
                "home-files/.config/git/config" = true;
              };
            };
          };
        };
      };

      nixos = {
        template = templates.nixos;
        params = [
          {
            name = "hostname";
            description = "Your system hostname as shown by `hostname -s`";
            placeholder = "example";
          }
        ] ++ om.templates.home.params;
        tests = {
          default = {
            systems = [ "x86_64-linux" "aarch64-linux" ];
            params = om.templates.home.tests.default.params // {
              hostname = "example";
            };
            asserts = {
              source = { };
              packages."nixosConfigurations.example.config.system.build.toplevel" = {
                "etc/profiles/per-user/john/bin/git" = true;
              };
            };
          };
        };
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
        tests = {
          default = {
            systems = [ "x86_64-darwin" "aarch64-darwin" ];
            params = om.templates.home.tests.default.params // {
              hostname = "example";
            };
            asserts = {
              source = { };
              packages."darwinConfigurations.example.config.system.build.toplevel" = {
                "etc/profiles/per-user/john/bin/git" = true;
              };
            };
          };
        };
      };
    };
  };
}
