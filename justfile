# Like GNU `make`, but `just` rustier.
# https://just.systems/man/en/chapter_19.html
# run `just` from this directory to see available commands

NIXOPTS := "--accept-flake-config"
NIX := "nix " + NIXOPTS

# Default command when 'just' is run without arguments
default:
  @just --list

# Print nix flake inputs and outputs
io:
  {{NIX}} flake metadata
  {{NIX}} flake show

# Update nix flake
update:
  {{NIX}} flake update

# Lint nix files
lint:
  {{NIX}} fmt

# Check nix flake
check:
  {{NIX}} flake check

# Manually enter dev shell
dev:
  {{NIX}} develop

# Build nix flake
build: lint check
  {{NIX}} build

# Remove build output link (no garbage collection)
clean:
  rm -f ./result

# Run nix flake to setup environment
run: lint check
  {{NIX}} run
