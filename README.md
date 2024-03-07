# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development. See [`home/default.nix`](home/default.nix) to see what's available.

## Getting Started

1. [Install Nix](https://nixos.asia/en/install).
1. Initialize your home-manager config using this repo as template:
    ```sh-session
    mkdir ~/nixconfig 
    cd ~/nixconfig
    nix flake init -t github:juspay/nix-dev-home
    nix run .#sd "runner" "$USER" flake.nix
    ```
    - Optionally, you may edit `./home/default.nix` to your liking.
1. Run `nix run`[^home-modify] to activate your configuration.
    - Does this fail to run? See the [Troubleshooting](#troubleshooting) section below.
1. Restart your terminal. 

After steps 1-4, you should expect to see the [starship](https://starship.rs/) prompt. 

Anytime you modify your home configuration in `./home/*.nix`, re-run `nix run` to activate the new configuration.

### Demo

A sample demo of the setup process is shown below:

[![asciicast](https://asciinema.org/a/572907.svg)](https://asciinema.org/a/572907)


[^home-modify]: Executing this step will modify the contents of your `$HOME` directory. You will be [warned before overwriting](https://nix-community.github.io/home-manager/index.html#sec-usage-dotfiles), but not before creating links to newly created configuration files in the nix store. Since home-manager does not currently provide an integrated and automated feature to eliminate the links it creates, be aware that if you would like to reverse this operation, you will need to curate your home directory manually.

## Details 

The configuration repo has `flake.nix` file in the current directory and a `./home/default.nix` file containing the home-manager configuration that you can review. It also has a [justfile](https://github.com/casey/just), which provides a set of recipes analogous to Make targets to interact with the nix flake.

You can then execute `nix develop`, to ensure you are in the development shell with [just](https://github.com/casey/just) installed, followed by `just run` to activate this configuration in your `$HOME`. On most systems you are likely to experience at least one of the issues mentioned below in [Troubleshooting](#troubleshooting). A more complete sequence might be
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

If you prefer, you can simply execute `nix run`, but using `just` will perform some additional validation and ensure you are able to use the other commands in the [justfile](./justfile).

To browse the capabilities of home-manager (and to see what else can go in your `./home/default.nix` -- such as shell aliases), consult [https://nix-community.github.io/home-manager/options.html](https://nix-community.github.io/home-manager/options.html). You can also run `man home-configuration.nix` in the terminal.

## Troubleshooting

### `error: opening lock file ...`

**Problem**: `nix run` shows an error like: `error: opening lock file '/nix/var/nix/profiles/per-user/utkarsh.pandey1/profile.lock': No such file or directory`

**Solution**: This is an instance of https://github.com/nix-community/home-manager/issues/4611. Run `sudo mkdir /nix/var/nix/profiles/per-user/$USER/ && sudo chown $USER /nix/var/nix/profiles/per-user/$USER` and try again.

### `Existing file ... is in the way of ...`

**Problem**: Running `nix run` (home-manager) complains `"Existing file ... is in the way of ..."`

**Solution**: Delete those existing dotfiles, and try again. In home-manager, you can configure your shell directly in Nix (for macOS zsh, this is [`programs.zsh.envExtra`](https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.envExtra)).

### Cannot use cache / cachix

**Problem**: Cannot use cachix: Running `nix run nixpkgs#cachix use nammayatri` (for example) does not succeed.

**Solution**: Add yourself to the `trusted-users` nix config and restart the nix daemon.

```sh
mkdir -p ~/.config/nix
echo "trusted-users = root $USER" > $HOME/.config/nix/nix.conf
sudo pkill nix-daemon
```

## FAQ

### But I use NixOS

You can embed this configuration inside your NixOS configuration, and thus share it with non-NixOS systems (like macOS and Ubuntu). See the "both" template of [https://github.com/srid/nixos-flake](https://github.com/srid/nixos-flake) for an example. If you don't want to share the configuration with macOS (ie., you use only Linux for development), see the "linux" template instead.

### `/nix/store` garbage collection

By default garbage collection is run automatically every week. If your projects use nix-direnv, you don't have to worry about having to download the dependencies again while in a remote area with limited internet access ([see prominent features of nix-direnv](https://github.com/nix-community/nix-direnv?tab=readme-ov-file#nix-direnv)).
