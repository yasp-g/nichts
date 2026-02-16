# Roadmap: Channel to Flake Migration

Tracking the transition from the installer's channel-based setup to a modular flake architecture.

## Source of Truth
- **Repo:** `github.com:yasp-g/nichts.git`
- **Workflow:** Commit and push changes, pull on each machine, rebuild locally
- **Multi-host:** `flake.nix` defines all machines (NixOS and nix-darwin) from day one

## Current State
- [x] NixOS installed on Intel MacBook Pro (2015)
- [x] Hyprland desktop environment working
- [x] Channel-based config symlinked to `/etc/nixos/`

## Phase 1: Minimal Flake Bootstrap
Get flakes working with the existing config before restructuring.

- [x] Create `flake.nix` with nixpkgs input (pinned to 25.11)
- [x] Move `configuration.nix` logic into flake's nixosConfigurations
- [x] First successful `sudo nixos-rebuild switch --flake .#mbp2015`
- [x] Remove symlinks from `/etc/nixos/` (no longer needed with flakes)

## Phase 2: Modular Structure
Extract reusable pieces into the planned directory layout.

- [ ] Create `hosts/nixbook/` with `default.nix` and `hardware.nix`
- [ ] Create `modules/core/` (timezone, locale, users, base packages)
- [ ] Create `modules/desktop/hyprland.nix` (Hyprland, Waybar, Wofi, greetd)
- [ ] Verify rebuild still works after restructure

## Phase 3: Home Manager Integration
Separate user dotfiles from system config.

- [ ] Add home-manager flake input
- [ ] Create `users/yasp/home.nix` for user-level config
- [ ] Move user packages and dotfiles to Home Manager
- [ ] Verify Hyprland config works via Home Manager

## Phase 4: Polish & Document
- [ ] Set up weekly garbage collection
- [ ] Update CLAUDE.md to reflect new structure
- [ ] Clean up commented boilerplate from old config

---

## Notes
- Always `git add` new files before rebuild (flakes can't see untracked files)
- Test each phase with a rebuild before moving to the next
- Keep the old `configuration.nix` as backup until Phase 2 is verified
