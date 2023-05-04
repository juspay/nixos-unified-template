# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development. Neovim pre-configured for Haskell Language Server is included as a key demonstration (try it with [haskell-template](https://github.com/srid/haskell-template).)

## Usage

[![asciicast](https://asciinema.org/a/572907.svg)](https://asciinema.org/a/572907)

Either click the green "Use this template" button above (on [Github](https://github.com/juspay/nix-dev-home)) and clone it locally, or run the following:

```sh
mkdir ~/mynixconfig && cd ~/mynixconfig
nix flake init -t github:juspay/nix-dev-home
```

(If you do not already have it, [install Nix](https://haskell.flake.page/nix) first)

This will create a `flake.nix` file and a `home.nix` in the current directory. 

- Edit `home.nix` to your liking (see [configuration example](https://nix-community.github.io/home-manager/index.html#sec-usage-configuration)). 
- Also, you must change the user name in `flake.nix` from `john` to your actual user name. 
- You can then run `nix run` to activate this configuration in your $HOME.
    - After running this, restart your terminal. Expect to see the [starship](https://starship.rs/) prompt. When you `cd` into a project containing `.envrc` configured for flakes (such as [haskell-template](https://github.com/srid/haskell-template)), you should be automatically be put in the `nix develop` shell along with a change to the starship prompt indicating the same.
    
To browse the capabilities of home-manager (and to see what else can go in your `home.nix` -- such as shell aliases), consult https://nix-community.github.io/home-manager/options.html

## Troubleshooting

- Running`nix run` (home-manager) complains `"Existing file ... is in the way of ..."`
    - Delete those existing dotfiles, and try again. In home-manager, you can configure your shell directly in Nix (for macOS zsh, this is [`programs.zsh.envExtra`](https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.envExtra)).
- Cannot use cachix: Running `nix run nixpkgs#cachix use nammayatri` (for example) does not succeed.
    - Add yourself to the trusted-users list and restart your macOS machine.
        ```sh
        mkdir -p ~/.config/nix
        echo "trusted-users = root $USER" > $HOME/.config/nix/nix.conf
        ```

## FAQ

### But I use NixOS

You can embed this configuration inside your NixOS configuration, and thus share it with non-NixOS systems (like macOS and Ubuntu). See the "both" template of https://github.com/srid/nixos-flake for an example. If you don't want to share the configuration with macOS (ie., you use only Linux for development), see the "linux" template instead.

