# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Nix configuration for two machines:
- **MacBook Pro 2015** — NixOS with Hyprland (x86_64-linux)
- **Mac Mini** — macOS with nix-darwin (aarch64-darwin, in progress — see `docs/mini-transition/`)

**Repository location:** `~/.config/nix-config/`

## Build Commands

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake .#mbp2015

# Clean up old generations manually (automatic weekly GC is configured)
nix-collect-garbage -d

# Update flake inputs
nix flake update
```

## Architecture

```
flake.nix                    # Entry point defining all hosts
├── hosts/                   # Machine-specific configs
│   └── mbp2015/            # MacBook Pro 2015
│       ├── default.nix     # Host config (boot, drivers, hostname)
│       └── hardware.nix    # Generated hardware config
├── modules/                 # Reusable NixOS modules
│   ├── core/               # Shared: timezone, users, base packages, GC
│   ├── desktop/            # Hyprland, greetd, PipeWire, fonts
│   └── nixpkgs.nix         # Mergeable unfree/insecure package options
└── users/                   # Home Manager configs
    └── jasper/
        ├── home.nix        # User packages, programs, dotfile mappings
        ├── hypr/           # Hyprland & hyprlock configs
        ├── ghostty/        # Terminal config
        └── waybar/         # Status bar config & styling
```

## Key Configuration Details

- **Desktop:** Hyprland (Wayland) with greetd/tuigreet, Waybar, Wofi
- **Terminal:** Ghostty
- **Audio:** PipeWire with ALSA and PulseAudio bridges
- **Hardware:** Intel GPU, Broadcom WiFi (unfree drivers)
- **User:** `jasper` with wheel, networkmanager, video groups
- **Dotfiles:** Managed via Home Manager's `xdg.configFile`

## Nix-Specific Gotchas

- **Unadded files invisible to flakes:** Always `git add` new files before rebuild
- **Unfree packages:** Use `allowedUnfreePackages` list in the relevant module (merges automatically)
- **Insecure packages:** Use `allowedInsecurePackages` list (same pattern)
- **FHS binaries fail:** Standard Linux binaries won't work; use `nix-ld` or find Nix packages
- **Never change `system.stateVersion`:** This is NOT the NixOS version; keep at initial install value
- **Waybar reload:** Waybar doesn't auto-reload; restart with `pkill waybar && hyprctl dispatch exec waybar`

## Secrets

Secrets are gitignored (`secrets/`, `*.key`, `*.pem`). Never commit credentials.
