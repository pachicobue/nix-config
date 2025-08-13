# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal NixOS configuration using standard Nix Flakes with the following structure:
- Standard flake.nix with nixosConfigurations and devShells
- Multi-machine support: desktop, WSL, and VM configurations
- Modular design with separate NixOS and Home Manager modules
- Japanese/English environment with Hyprland on desktop/VM, minimal on WSL

## Essential Commands

### Development Environment
```bash
# Enter development shell (required first)
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

# Apply configuration changes
switch desktop    # For desktop configuration
switch wsl        # For WSL configuration  
switch vm         # For VM configuration
```

### Validation and Testing
```bash
# Validate flake configuration
nix flake check

# Update dependencies (when needed)
nix flake update my-nix-secret    # Private secrets update
nix flake update                  # All dependencies
```

### Git Integration
```bash
# SSH key setup for private flake dependency
ssh-keygen
gh ssh-key add ~/.ssh/id_ed25519.pub
```

## Architecture Overview

### Flake Structure
- `flake.nix`: Main entry point with standard nixosConfigurations and devShells
- Private secrets via `my-nix-secret` flake dependency

### Configuration Hierarchy
```
host/
├── desktop/    # Full desktop with Hyprland, gaming, graphics
├── wsl/        # Minimal WSL2 environment  
└── vm/         # VM configuration

module/
├── nixos/      # System-level NixOS modules
│   ├── common/ # Base system configuration
│   └── *.nix   # Feature modules (audio, gaming, nvidia, etc.)
└── home/       # Home Manager user environment
    ├── common/ # Base CLI tools and shell
    ├── ai/     # AI tools (claude-code, smartcat)
    └── *.nix   # Desktop applications and services
```

### Module System
- `module/nixos/common.nix`: Base system (fonts, console, nix config, locale, direnv)
- `module/home/common.nix`: Base user environment (shell, CLI tools, text editors)
- Feature modules are imported conditionally per host
- Catppuccin theming applied consistently across applications

### Key Features by Host
- **Desktop**: Hyprland + gaming + NVIDIA + Japanese input + full desktop apps
- **WSL**: Minimal environment with essential CLI tools only
- **VM**: Similar to desktop but without hardware-specific modules

## Development Workflow

1. Make changes to configuration files
2. Run `nix flake check` to validate syntax
3. Apply with appropriate `switch <hostname>` command
4. Changes take effect immediately (system) or after re-login (user session)

## Important Notes

- Always work within `nix develop` shell for proper environment
- The `switch` command is a custom script that runs `nixos-rebuild switch --flake`
- Private secrets are managed through separate git repository
- Configuration supports both x86_64-linux (desktop) and is architecture-flexible
