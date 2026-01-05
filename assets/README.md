# Demo Environment Setup

This directory contains the setup for recording demo videos of the **nixos-unified-template project**. The demos showcase the onboarding experience and key features of the template.

## Prerequisites

- **Nix with flakes enabled**: You need Nix installed with experimental features `nix-command` and `flakes` enabled. Follow this [guide](https://nixos.wiki/wiki/Flakes#Enable_flakes_temporarily) to enable flakes in your system.

## Steps to reproduce demo

1. **Enter the development environment**:
   ```bash
   nix develop
   ```

2. **Run the VHS tape**:
   ```bash
   vhs demo.tape
   ```

3. **Wait for completion**:
   VHS will automatically:
   - Execute all commands in the tape file
   - Capture the terminal output
   - Generate `out.gif` and `out.mp4`

4. **Clean the results**:
   ```bash
   rm -rf ./nixconfig
   git restore out.*
   ```

## Additional Resources

- [VHS Documentation](https://github.com/charmbracelet/vhs)
- [nixos-unified-template Main README](https://github.com/juspay/nixos-unified-template/blob/main/README.md)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)
