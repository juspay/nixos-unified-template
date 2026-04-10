# AGENTS

This is a Nix flake template for home-manager, NixOS, and nix-darwin configurations using [nixos-unified](https://nixos-unified.org/).

## Key commands

- `nix run` — activate the configuration
- `nix flake check` — check the flake
- `nix fmt` — format nix files

## Structure

- `flake.nix` — flake definition with autowiring via nixos-unified
- `configurations/` — system and home-manager configurations
- `modules/` — reusable NixOS/home-manager/nix-darwin modules
