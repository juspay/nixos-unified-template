# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development. Neovim pre-configured for Haskell Language Server is included as a key demonstration (try it with [haskell-template](https://github.com/srid/haskell-template)).

## Usage

[![asciicast](https://asciinema.org/a/572907.svg)](https://asciinema.org/a/572907)

Either click the green "Use this template" button above (on [Github](https://github.com/juspay/nix-dev-home)) and clone it locally, or run the following:

```sh
mkdir ~/mynixconfig && cd ~/mynixconfig
nix flake init -t github:juspay/nix-dev-home
nix flake update  # Update inputs to use latest software
```

(If you do not already have it, [install Nix](https://nixos.asia/en/install) first)

This will create a `flake.nix` file in the current directory and a `./home` directory containing the home-manager configuration that you can review starting with `./home/default.nix`. It will also create a [justfile](https://github.com/casey/just), which provides a set of recipes analogous to Make targets to interact with the nix flake.

> [!NOTE]
> Executing commands below will modify the contents of your `$HOME` directory. You will be [warned before overwriting](https://nix-community.github.io/home-manager/index.html#sec-usage-dotfiles), but not before creating links to newly created configuration files in the nix store. Since home-manager does not currently provide an integrated and automated feature to eliminate the links it creates, be aware that if you would like to reverse this operation, you will need to curate your home directory manually.

- Edit the contents of `./home` to your liking (see [configuration example](https://nix-community.github.io/home-manager/index.html#sec-usage-configuration)).
- You must also change the user name in `flake.nix` from `runner` to your actual user name. `runner` is used by default for compatibility with [github actions](https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables).
- You can then execute `nix develop`, to ensure you are in the development shell with [just](https://github.com/casey/just) installed, followed by `just run` to activate this configuration in your `$HOME`. On most systems you are likely to experience at least one of the issues mentioned below in [Troubleshooting](#troubleshooting). A more complete sequence might be

    <details>

    <summary>nix-dev-env setup</summary>

    ```sh
    > nix develop
    (nix:nix-dev-home-env) > rm ~/.bashrc ~/.profile && just run && direnv allow
    (nix:nix-dev-home-env) > exit
    > bash
    runner on 12ca6a64c923 work on  feature/branch via ❄️  impure (nix-dev-home-env) 
    ⬢ [Docker] ❯ 
    ```

    </details>

- If you prefer, you can simply execute `nix run`, but using `just` will perform some additional validation and ensure you are able to use the other commands in the [justfile](./justfile).
  - After running this, restart your terminal. Expect to see the [starship](https://starship.rs/) prompt. When you `cd` into a project containing `.envrc` configured for flakes (such as [haskell-template](https://github.com/srid/haskell-template)), you should automatically be put in the `nix develop` shell along with a change to the starship prompt indicating the same.

To browse the capabilities of home-manager (and to see what else can go in your `./home` -- such as shell aliases), consult [https://nix-community.github.io/home-manager/options.html](https://nix-community.github.io/home-manager/options.html). You can also run `man home-configuration.nix` in the terminal.

## Troubleshooting

- Running `nix run` (home-manager) complains `"Existing file ... is in the way of ..."`
  - Delete those existing dotfiles, and try again. In home-manager, you can configure your shell directly in Nix (for macOS zsh, this is [`programs.zsh.envExtra`](https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.envExtra)).
- Cannot use cachix: Running `nix run nixpkgs#cachix use nammayatri` (for example) does not succeed.
  - Add yourself to the trusted-users list and restart your macOS machine.

    ```sh
    mkdir -p ~/.config/nix
    echo "trusted-users = root $USER" > $HOME/.config/nix/nix.conf
    ```

## FAQ

### But I use NixOS

You can embed this configuration inside your NixOS configuration, and thus share it with non-NixOS systems (like macOS and Ubuntu). See the "both" template of [https://github.com/srid/nixos-flake](https://github.com/srid/nixos-flake) for an example. If you don't want to share the configuration with macOS (ie., you use only Linux for development), see the "linux" template instead.
