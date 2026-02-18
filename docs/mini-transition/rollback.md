# Rollback Guide

How to undo things safely at every stage of the transition.

## Core Principle

Nix is designed for safe rollbacks. Every `switch` operation creates a new "generation" while keeping the previous one intact. You can always go back.

---

## Rolling Back Home Manager

```bash
# List all generations
home-manager generations

# Activate a specific previous generation (copy the path from the list above)
/nix/var/nix/profiles/per-user/<username>/home-manager-<N>-link/activate

# Or fix your config and rebuild
home-manager switch --flake ~/.config/nix-config#yasp
```

**What this rolls back:** Dotfiles, user-level packages, shell config, anything in `home.nix`.

**What this does NOT roll back:** System-level changes (macOS defaults, Homebrew casks). Those are nix-darwin's domain.

---

## Rolling Back nix-darwin

```bash
# List generations
darwin-rebuild switch --list-generations

# Roll back to the previous generation
darwin-rebuild switch --rollback

# Or switch to a specific generation
darwin-rebuild switch --switch-generation <N>
```

**What this rolls back:** System packages, macOS defaults (partially — some require logout/reboot), Homebrew cask declarations, nix-darwin services, and Home Manager (since it's a module).

**Note on macOS defaults:** Rolled-back defaults may not take visible effect until you `killall Dock`, `killall Finder`, or log out/in.

---

## Rolling Back Individual Package Changes

If you migrated a package from Homebrew to Nix and the Nix version doesn't work:

```bash
# Re-install via Homebrew
brew install <package>

# Remove from Nix profile (if installed imperatively)
nix profile list  # find the index
nix profile remove <index>

# Or remove from home.nix / configuration.nix and rebuild
```

---

## Rolling Back the Entire Nix Installation

If you need to completely remove Nix:

```bash
/nix/nix-installer uninstall
```

This removes:
- The `/nix` APFS volume and store
- The Nix daemon (launchd service)
- Shell profile hooks
- System users/groups created for the daemon

This does NOT touch:
- Homebrew and its packages
- Your macOS system
- Your home directory (except removing Nix profile symlinks)
- Your config repo (that's just files in `~/.config/nix-config`)

---

## Recovering a Broken Shell

If Home Manager or nix-darwin breaks your shell config and you can't open a terminal:

### Option 1: macOS Terminal with explicit shell
Open Terminal.app (or iTerm2), then in the menu: Shell → New Command → type `/bin/zsh --no-rcs` to get a shell without loading any config files.

### Option 2: SSH from another machine
If you have SSH enabled, connect from your MacBook Pro and fix the config.

### Option 3: Recovery via previous generation
From the no-rcs shell:
```bash
# Source Nix manually
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Roll back Home Manager
home-manager generations
# Activate the last working generation
```

---

## Before Any Destructive Operation

Checklist to run before removing packages, overwriting configs, or switching cleanup modes:

- [ ] Current generation noted: `home-manager generations | head -1` and/or `darwin-rebuild switch --list-generations | head -1`
- [ ] Backup of any file being overwritten: `cp <file> ~/.config-backup/`
- [ ] Git status clean: `cd ~/.config/nix-config && git status`
- [ ] Last working state committed: `git log --oneline -1`
