# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development

## Usage

Either click the green "Use this template" button above (on [Github](https://github.com/juspay/nix-dev-home)) and clone it locally, or run the following:

```sh
mkdir ~/mynixconfig && cd ~/mynixconfig
nix flake init -t github:juspay/nix-dev-home
```

This will create a `flake.nix` file and a `home.nix` in the current directory. 

- Edit `home.nix` to your liking (see [configuration example](https://nix-community.github.io/home-manager/index.html#sec-usage-configuration)). 
- Also, you must change the user name in `flake.nix` from `john` to your actual user name. 
- You can then run `nix run` to activate this configuration in your $HOME.
    - After running this, restart your terminal. Expect to see the [https://starship.rs/] prompt. When you `cd` into a project containing `flake.nix` with devShell, you should be automatically be put in the `nix develop` shell along with a change to the starship prompt indicating the same.

## Caveats

`nix run` may complain of existing dotfiles in your $HOME. You should delete them and try again because Nix will be managing your dotfiles going forward.

## FAQ

### But I use NixOS

You can embed this configuration inside your NixOS configuration, and thus share it with non-NixOS systems (like macOS and Ubuntu). See the "both" template of https://github.com/srid/nixos-flake for an example.