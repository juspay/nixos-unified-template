# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development. Neovim pre-configured for Haskell Language Server is included as a key demonstration (try it with [haskell-template](https://github.com/srid/haskell-template)).

## Usage

Before proceeding, [install Nix](https://nixos.asia/en/install) first.

1. Create a local repository mirroring this template. There are two ways to do this; the first one is favoured over the rest; pick your choice:
    1. Click the green "Use this template" button above on Github, and then clone your repo locally: ![](https://private-user-images.githubusercontent.com/3998/293769444-4a67d757-7901-4140-ac0b-49d3caf7e4c9.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQyMjM1MzksIm5iZiI6MTcwNDIyMzIzOSwicGF0aCI6Ii8zOTk4LzI5Mzc2OTQ0NC00YTY3ZDc1Ny03OTAxLTQxNDAtYWMwYi00OWQzY2FmN2U0YzkucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEwMiUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMDJUMTkyMDM5WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9MTMyYjI2MjZlYWQxMjEwNzRmODlkMmMwY2FlMzliOTM3M2NkZTU2MmFkNmRjNDllOWUxOTM3ZDFjMTY0ZGE0MSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.clV5VBP2eifM3kFx0bXjijKENpm4lg2UmDGpxBc99bw)
        ```sh-session
        # Replace this URL with your repo URL
        git clone https://github.com/user/nixconfig.git
        cd nixconfig
        # Update to latest software
        nix flake update
        ```
    1. Or, run `nix flake init` on an empty directory
        ```sh-session
        mkdir nixconfig 
        cd nixconfig
        nix flake init -t github:juspay/nix-dev-home
        ```
1. Open `flake.nix` and set `myUserName` to your user name. You can use `echo $USER` to get your user name.[^runner]
    - Optionally, you may edit `./home/default.nix` to your liking.
1. Run either `nix run` or `nix develop -c just run` to active your configuration.
1. Restart your terminal. 
    - Expect to see the [starship](https://starship.rs/) prompt. When you `cd` into a project containing `.envrc` configured for flakes (such as this very repository), you should automatically be put in the `nix develop` shell along with a change to the starship prompt indicating the same. If not, run `direnv allow` once.

[^runner]: `runner` is used by default for compatibility with [github actions](https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables).

> [!NOTE]
> Executing step 4 above will modify the contents of your `$HOME` directory. You will be [warned before overwriting](https://nix-community.github.io/home-manager/index.html#sec-usage-dotfiles), but not before creating links to newly created configuration files in the nix store. Since home-manager does not currently provide an integrated and automated feature to eliminate the links it creates, be aware that if you would like to reverse this operation, you will need to curate your home directory manually.

### Details 

The configuration repo has `flake.nix` file in the current directory and a `./home` directory containing the home-manager configuration that you can review starting with `./home/default.nix`. It also has a [justfile](https://github.com/casey/just), which provides a set of recipes analogous to Make targets to interact with the nix flake.

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

To browse the capabilities of home-manager (and to see what else can go in your `./home` -- such as shell aliases), consult [https://nix-community.github.io/home-manager/options.html](https://nix-community.github.io/home-manager/options.html). You can also run `man home-configuration.nix` in the terminal.


### Demo

A sample demo of the setup process is shown below:

[![asciicast](https://asciinema.org/a/572907.svg)](https://asciinema.org/a/572907)


## Troubleshooting

- `nix run` shows an error like: `error: opening lock file '/nix/var/nix/profiles/per-user/utkarsh.pandey1/profile.lock': No such file or directory`
  - This is an instance of https://github.com/nix-community/home-manager/issues/4611. Run `sudo mkdir /nix/var/nix/profiles/per-user/$USER/ && sudo chown $USER /nix/var/nix/profiles/per-user/$USER` and try again.
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
