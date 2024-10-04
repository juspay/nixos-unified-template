[![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://nixos.zulipchat.com/#narrow/stream/413950-nix)

# nixos-unified-template

A multi-platform Nix configuration template optimized as development environment (includes direnv, neovim with LSP and such), based on [nixos-unified]. See [`./modules`](modules/) to see what's available.

[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
[NixOS]: https://nixos.asia/en/nixos-tutorial
[nixos-unified]: https://nixos-unified.org

## Status

We currently support [home-manager] (see `./modules/home`), [nix-darwin] (see `./modules/darwin`) and [NixOS] (see `./modules/nixos`).

| Platform    | Supported By                              |
|-------------|-------------------------------------------|
| macOS       | ✅ [home-manager] and/or [nix-darwin]   |
| NixOS       | ✅ [home-manager] and ✅ [NixOS]  |
| Other Linux | ✅ [home-manager] only                       |

## Getting Started

### On NixOS

If you use, or intend to use, [NixOS]:

1. Install NixOS from [Graphical ISO image](https://nixos.org/download/#download-nixos) and reboot.
1. Ensure that `/etc/nixos/{configuration.nix, hardware-configuration.nix}` are in place.
1. In a terminal, become `root` and initialize our template under `/etc/nixos`:
    ```sh-session
    sudo su -
    cd /etc/nixos
    nix --accept-flake-config --extra-experimental-features "nix-command flakes" \
      run github:juspay/omnix -- \
      init github:juspay/nixos-unified-template#nixos -o .
    # Replace HOSTNAME with the hostname you entered above.
    mv configuration.nix hardware-configuration.nix ./configurations/nixos/HOSTNAME/
    nix --extra-experimental-features "nix-command flakes" run
    ```
1. At this point, you can move `/etc/nixos` to anywhere, and initialize a Git repository to track future changes.

### On non-NixOS

If you are on macOS or running other Linux distros:

1. [Install Nix](https://nixos.asia/en/install):
    ```sh-session
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
      sh -s -- install --no-confirm --extra-conf "trusted-users = $(whoami)"
    ```
1. Open a new terminal; Initialize[^omnix] your Nix configuration using this repo as template:
    ```sh-session
    mkdir ~/nixconfig && cd ~/nixconfig
    nix --accept-flake-config run github:juspay/omnix -- \
      init github:juspay/nixos-unified-template -o .
    ```
    <img width="1092" alt="image" src="https://github.com/user-attachments/assets/1341d200-d894-488c-ba74-42d8830cc6f7">

    - It will prompt to you choose between [home-manager] only configuration and [nix-darwin] configuration (ignore the [NixOS] template). The latter includes [home-manager] as well.
    - Optionally, you may edit `./modules/{home,darwin}/*.nix` to your liking.
1. Run `nix run` (or the appropriate command printed by the above command) to activate your configuration.
    - Does this fail to run? See the [Troubleshooting](#troubleshooting) section below.
1. Restart your terminal.

After steps 1-4, you should expect to see the [starship](https://starship.rs/) prompt:

<img width="236" alt="image" src="https://github.com/user-attachments/assets/bea3a7e5-b06a-483f-b76b-5c3865ce5e55">

Whenever you modify your configuration in `./modules/*/*.nix`, you should re-run `nix run` to activate the new configuration.

[^omnix]: We use [omnix](https://omnix.page/om/init.html) to initialize this repository template.

## Details

The configuration repo has `flake.nix` file in the current directory and some `./modules/{home,darwin,nixos}/*.nix` files containing the [home-manager], [nix-darwin] and [NixOS] configurations respectively that you can review. It also has a [justfile](https://github.com/casey/just), which provides a set of recipes analogous to Make targets to interact with the nix flake.

You can then execute `nix develop`, to ensure you are in the development shell with [just](https://github.com/casey/just) installed, followed by `just run` (or `nix run`) to activate this configuration in your system.

If you prefer, you can simply execute `nix run`, but using `just` will perform some additional validation and ensure you are able to use the other commands in the [justfile](./justfile).

To browse the capabilities of [home-manager] (and to see what else can go in your `./modules/home/*.nix` -- such as shell aliases), consult [home-manager options reference](https://nix-community.github.io/home-manager/options.xhtml). You can also run `man home-configuration.nix` in the terminal.

## Troubleshooting

### `error: opening lock file ...`

**Problem**: When using home-manager, `nix run` shows an error like: `error: opening lock file '/nix/var/nix/profiles/per-user/utkarsh.pandey1/profile.lock': No such file or directory`

**Solution**: This is an instance of https://github.com/nix-community/home-manager/issues/4611. Run `sudo mkdir /nix/var/nix/profiles/per-user/$(whoami)/ && sudo chown $(whoami) /nix/var/nix/profiles/per-user/$(whoami)` and try again.

## FAQ

### `/nix/store` garbage collection

By default, [home-manager] is configured to run garbage collection automatically every week. If your projects use nix-direnv, you don't have to worry about having to download the dependencies again while in a remote area with limited internet access ([see prominent features of nix-direnv](https://github.com/nix-community/nix-direnv#nix-direnv)).
