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

# Lint nix files
lint:
    nix fmt

# Check nix flake
check:
    nix flake check

# Run nix flake to setup environment
run: lint check
    nix run
