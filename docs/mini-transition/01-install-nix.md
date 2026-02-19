# Phase 1: Install Nix

**Status:** `NOT_STARTED`
**Prerequisites:** Phase 0 complete
**Estimated time:** 1 session
**Outcome:** Nix package manager installed and functional with flakes enabled

## Overview

Install Nix using the Determinate Systems installer. This creates a `/nix` APFS volume, installs the Nix daemon, and configures shell integration. Homebrew remains fully functional alongside Nix.

## Pre-Flight Checks

- [ ] Verify macOS is up to date (or at least stable — don't install mid-OS-update)
- [ ] Verify Time Machine backup is current
- [ ] Note current disk usage: `df -h /`
- [ ] Confirm shell profile locations: check which of `~/.zshrc`, `~/.zprofile`, `~/.zshenv` exist

## Installation Checklist

- [ ] Install Nix via Determinate Systems installer:
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```
- [ ] **Open a new terminal** (required for PATH changes to take effect)
- [ ] Verify installation: `nix --version`
- [ ] Verify flakes are enabled: `nix flake --help` should work without errors
- [ ] Verify the daemon is running: `sudo launchctl list | grep nix`
- [ ] Check the APFS volume was created: `diskutil list | grep -i nix`
- [ ] Verify the Nix store works: `nix-shell -p hello --run hello`

## Post-Install Configuration

- [ ] Review what the installer added to your shell profile:
  ```bash
  cat ~/.zshrc  # or ~/.zshenv / ~/.zprofile — check all
  ```
- [ ] Note the exact line(s) added (you'll need to account for these when Home Manager takes over shell config)
- [ ] Verify PATH ordering — Nix paths should come before Homebrew:
  ```bash
  echo $PATH | tr ':' '\n' | head -20
  ```
  Expected: `/nix/...` paths appear before `/opt/homebrew/...` paths
- [ ] Test a basic `nix shell` invocation:
  ```bash
  nix shell nixpkgs#ripgrep --command rg --version
  ```
- [ ] Test `nix search`:
  ```bash
  nix search nixpkgs ripgrep
  ```

## Verify Homebrew Coexistence

- [ ] Confirm Homebrew still works: `brew --version`
- [ ] Confirm a Homebrew-installed tool still works (pick one from your KEEP list)
- [ ] Confirm no PATH conflicts for tools only in Homebrew

## Understanding What Was Installed

The Determinate installer sets up:
- **`/nix/store`** — Immutable package store (on its own APFS volume)
- **`/nix/var`** — Nix daemon state, profiles, channels
- **Nix daemon** — Background service that handles builds (runs as root)
- **Shell hook** — Sources Nix environment in new shells
- **Flakes + nix-command** — Enabled by default with Determinate installer

Key commands to know:
- `nix shell nixpkgs#<pkg>` — Temporarily add a package to your shell
- `nix search nixpkgs <query>` — Search available packages
- `nix profile install nixpkgs#<pkg>` — Imperatively install a package to your profile
- `nix profile list` — List imperatively installed packages
- `nix profile remove <index>` — Remove a package from your profile
- `nix-collect-garbage -d` — Remove old generations and free disk space


## Notes for Claude Code Agent

- The Determinate installer is interactive — let the user run it and respond to prompts.
- After installation, always open a **new terminal session** before testing.
- If PATH ordering is wrong, do NOT try to fix it by editing shell profiles manually — note it and it will be resolved when Home Manager takes over shell config.
- If the installer fails, check: enough disk space, no conflicting prior Nix install, macOS SIP is enabled (required for APFS volume).
- Do not install packages imperatively via `nix profile install` beyond testing — packages will be managed declaratively in Phase 2+.
- Log the installer version and any non-default choices in `reference/decisions.md`.

## Completion Criteria

- `nix --version` works in a new terminal
- Flakes are functional (`nix flake --help` works)
- Homebrew still works alongside Nix
- No shell or PATH regressions
