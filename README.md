# nix-dev-home

A [`home-manager`](https://github.com/nix-community/home-manager) template providing useful tools &amp; settings for Nix-based development

## Usage

Either click the green "Use this template" button above (on [Github](https://github.com/juspay/nix-dev-home)) and clone it locally, or run the following:

```sh
mkdir ~/mynixconfig && cd ~/mynixconfig
nix flake init -t github:juspay/nix-dev-home
```

This will create a `flake.nix` file in the current directory, which you can edit to your liking (see [configuration example](https://nix-community.github.io/home-manager/index.html#sec-usage-configuration)). At minimum, you must change the user name from `john` to your actual user name. You can then run `nix run` to activate this configuration in your $HOME.

## Caveats

`nix run` may complain of existing dotfiles in your $HOME. You should delete them and try again because Nix will be managing your dotfiles going forward.