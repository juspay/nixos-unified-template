# Allow using this repo in `nix flake init`
{ inputs, ... }:
{
  flake = rec {
    templates.default = {
      description = "A `home-manager` template providing useful tools & settings for Nix-based development";
      welcomeText = ''
        You have just created a home-manager flake.nix.
  
        - Edit `nix/modules/home/*.nix` to customize your home-manager configuration.
        - Run `nix run` to apply the configuration.
  
        Enjoy!
      '';
      path = builtins.path {
        path = inputs.self;
        filter = path: _: with inputs.nixpkgs.lib;
          !(hasSuffix "LICENSE" path ||
            hasSuffix "README.md" path ||
            hasSuffix ".github/" path);
      };
    };
  
    # https://omnix.page/om/init.html#spec
    om.templates.nix-dev-home = {
      template = templates.default;
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
        {
          name = "github-ci";
          description = "Include GitHub Actions workflow configuration";
          paths = [ ".github" ];
          value = false;
        }
      ];
    };
  };
}
