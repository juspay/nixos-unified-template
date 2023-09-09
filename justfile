# Like GNU `make`, but `just` rustier.
# https://just.systems/man/en/chapter_19.html
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
# Run 'just <command>' to execute a command.
default: help

# Display help
help:
  @printf "\nRun 'just -n <command>' to print what would be executed...\n\n"
  @just --list
  @echo "\n...by running 'just <command>'.\n"
  @echo "This message is printed by 'just help' and just 'just'.\n"

# Print nix flake inputs and outputs
io:
  nix flake metadata
  nix flake show

# Update nix flake
update:
  nix flake update

# Lint nix files
lint:
  nix fmt

# Check nix flake
check:
  nix flake check

# Build nix flake
build: lint check
  nix build

# Remove build output link (no garbage collection)
clean:
  rm -f ./result

# Run nix flake to setup environment
run: lint check
  nix run
