# Demo Environment Setup

This directory contains the setup for recording demo videos of the **nixos-unified-template project**. The demos showcase the onboarding experience and key features of the template.

## Prerequisites

- **Nix with flakes enabled**: You need Nix installed with experimental features `nix-command` and `flakes` enabled. Follow this [guide](https://nixos.wiki/wiki/Flakes#Enable_flakes_temporarily) to enable flakes in your system.

## Quick Start

Enter the development shell with all required tools:

```bash
nix develop
```

This will provide you with:
- **vhs**: Terminal recording tool for creating GIFs and videos
- **ffmpeg**: Video processing
- **ttyd**: Terminal sharing tool
- **chromium**: Browser for testing
- **tree**: Directory visualization (used in the demo)
- Additional clipboard tools (commented out, uncomment if needed):
  - **xclip** (For X11)
  - **wl-clipboard** (For Wayland)
  
## Recording a Demo

### Overview

The demo is scripted using [VHS](https://github.com/charmbracelet/vhs), which automates terminal interactions and outputs to both GIF and MP4 formats.

### Demo Script

The demo recording is defined in `demo.tape`. This file contains:
- Terminal configuration (shell, font size, dimensions, styling)
- Output formats (GIF and MP4)
- Automated typing and command execution
- Timing controls for realistic playback

### Demo Stages

The current demo has two main stages:

#### Stage 1: Module Generation
- Runs `omnix init` to initialize the template
- Navigates through the interactive prompts
- Enters user information (hostname, name, email)
- Generates the configuration structure

#### Stage 2: Module Exploration
- Displays the generated directory structure using `tree`
- Shows the organized layout of the configuration

### Recording Process

1. **Enter the development environment**:
   ```bash
   nix develop
   ```

2. **Run the VHS tape**:
   ```bash
   vhs demo.tape
   ```

3. **Wait for completion**: VHS will automatically:
   - Execute all commands in the tape file
   - Simulate user input with realistic typing speed
   - Capture the terminal output
   - Generate `out.gif` and `out.mp4`

### Output Files

After recording, you'll find:
- `out.gif`: Animated GIF suitable for README and documentation
- `out.mp4`: Video file for higher quality playback

## Customizing the Demo

### Modifying the Script

Edit `demo.tape` to customize the demo. Key sections:

**Terminal Configuration**:
```vhs
Set Shell fish
Set FontSize 16
Set Height 1000
Set Margin 8
Set MarginFill "#7E7EFF"
Set BorderRadius 10
Set CursorBlink false
```

**Typing Commands**:
```vhs
Type "your command here"
Enter
Sleep 2s
```

**Timing**:
- `Sleep Xs`: Wait X seconds
- `Sleep Xms`: Wait X milliseconds
- `Type@0.01`: Type at custom speed

Additionally, for copy-paste kind of effect of the terminal commands in the demo, the `demo.tape` file can be configured as follows
```diff
Require tree
# For Xorg
+ Require xclip
# For Wayland
+ Require wl-copy
+ Require wl-paste
...

# Stage 1: Module Generation
- Type "nix run nixpkgs#omnix -- init github:juspay/nixos-unified-template -o ./nixconfig && cd ./nixconfig"
+ Copy "nix run nixpkgs#omnix -- init github:juspay/nixos-unified-template -o ./nixconfig && cd ./nixconfig"
+ Paste
...

# Stage 2: Module Exploration
- Type@0.01 "clear"
+ Copy "clear"
+ Paste
Enter
- Type "tree"
+ Copy "tree"
+ Paste
...

```

## Additional Resources

- [VHS Documentation](https://github.com/charmbracelet/vhs)
- [nixos-unified-template Main README](https://github.com/juspay/nixos-unified-template/blob/main/README.md)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)
