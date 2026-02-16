# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal NixOS configuration for a fleet of machines, currently in early development with a single Intel MacBook Pro (2015) running Hyprland.

**Repository location:** `~/nixos-config/`

The configuration files (`configuration.nix`, `hardware-configuration.nix`) are symlinked to `/etc/nixos/` where NixOS expects them. This allows version control in the home directory while NixOS reads from its standard location.

## Build Commands

```bash
# Apply configuration changes (current monolithic setup)
sudo nixos-rebuild switch

# Future flake-based rebuild (after migration)
sudo nixos-rebuild switch --flake .#nixbook

# Clean up old generations (Nix keeps all previous versions)
nix-collect-garbage -d
```

## Architecture

**Current State:** Monolithic configuration in `configuration.nix` with hardware in `hardware-configuration.nix`.

**Planned Migration:** Modular flake-based structure:
```
flake.nix                    # Dispatcher defining all hosts
├── hosts/                   # Machine-specific configs (hardware, drivers)
│   ├── macbook-2015/
│   └── mac-mini-m3/
├── modules/                 # Reusable components
│   ├── core/               # Shared: timezone, locale, users
│   ├── desktop/            # Hyprland, Waybar
│   └── services/           # Docker, NAS, Nginx
└── users/                  # Home Manager dotfiles
```

## Key Configuration Details

- **Desktop:** Hyprland (Wayland tiling WM) with greetd/tuigreet, Waybar, Wofi
- **Terminal:** Ghostty
- **Audio:** PipeWire with ALSA and PulseAudio bridges
- **Hardware:** Intel GPU (OpenGL enabled), Broadcom WiFi (requires unfree drivers)
- **User:** `yasp` with wheel, networkmanager, video groups

## Nix-Specific Gotchas

- **Unadded files are invisible:** Flakes cannot see files not tracked by git (`git add` first)
- **Unfree packages:** Must be explicitly allowed in `allowUnfreePredicate` (currently: broadcom-sta, claude-code)
- **Insecure packages:** Some drivers require `permittedInsecurePackages` listing
- **FHS binaries fail:** Standard Linux binaries won't work; use `nix-ld` or find Nix packages
- **Never change `system.stateVersion`:** This is NOT the NixOS version and should remain at initial install value

## Secrets

Secrets are gitignored (`secrets/`, `*.key`, `*.pem`). Never commit credentials.
