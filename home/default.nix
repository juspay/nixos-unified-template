{ flake, pkgs, ... }:
{
  imports = [
    ./nix-index.nix
    ./neovim.nix # Comment this out if you do not want to setup Neovim.
  ];

  # Recommended Nix settings
  nix = {
    # Which Nix version to use
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix
    package = pkgs.nix;

    registry.nixpkgs.flake = flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc

    # Garbage collect the Nix store
    gc = {
      automatic = true;
      # Change how often the garbage collector runs (default: weekly)
      # frequency = "monthly";
    };
  };

  # nixpkgs settings
  nixpkgs = {
    overlays = [
      # Add a package to nixpkgs
      (final: prev: {
        # Omnix is not yet upstreamed
        omnix = flake.inputs.omnix.packages.${pkgs.system}.default;
      })
    ];
  };

  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    omnix

    # Dev
    tmate

    # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
    # work.
    less
  ];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # Programs natively supported by home-manager.
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };

    # Better `cat`
    bat.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;

    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };

    # https://nixos.asia/en/direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        # Make direnv messages less verbose
        hide_env_diff = true;
      };
    };

    # https://nixos.asia/en/git
    git = {
      enable = true;
      # userName = "John Doe";
      # userEmail = "johndoe@example.com";
      ignores = [ "*~" "*.swp" ];
      aliases = {
        ci = "commit";
      };
      extraConfig = {
        # init.defaultBranch = "master";
        # pull.rebase = "false";
      };
    };
    lazygit.enable = true;

  };
}
