# Phase 4: Introduce nix-darwin

**Status:** `IN_PROGRESS`
**Prerequisites:** Phases 2 and 3 complete (Home Manager running with packages and dotfiles)
**Estimated time:** 2–4 sessions
**Outcome:** System-level macOS config managed declaratively via nix-darwin, with Home Manager integrated as a module

---

## Current Progress (2026-03-02)

### Completed

- [x] Add nix-darwin to flake (pinned to `nix-darwin-25.11` branch, repo moved to `nix-darwin/nix-darwin`)
- [x] Create `hosts/mini/default.nix` with: `system.stateVersion = 6`, nix settings, GC (weekly launchd), `programs.zsh.enable`, `system.primaryUser`, `users.users.jasper.home`, `networking.hostName`, unfree packages via `modules/nixpkgs.nix`
- [x] Bootstrap nix-darwin (`nix run nix-darwin -- switch --flake .#mini`)
- [x] Uncomment `darwinConfigurations.mini` in `flake.nix`, remove standalone `homeConfigurations.jasper`
- [x] Import `modules/nixpkgs.nix` and consolidate unfree handling (`claude-code`, `keymapp`)
- [x] Migrate HM zsh config: `initExtraFirst`/`initExtra` → `initContent` with `lib.mkMerge`/`lib.mkBefore`
- [x] Migrate casks to Nix packages: `aerospace`, `claude-code`, `ice-bar`, `stats`, `nerd-fonts.meslo-lg`
- [x] Add homebrew module for `ghostty` (nixpkgs package is Linux-only, no `aarch64-darwin`)
- [x] Remove `brew shellenv` and manual Nix PATH hack from zsh `initContent` (nix-darwin manages PATH via `set-environment`)
- [x] Remove `tfenv` from PATH (replaced by `tenv` in Phase 2)
- [x] Uninstall migrated Homebrew casks (`aerospace`, `claude-code`, `font-meslo-lg-nerd-font`, `stats`, `jordanbaird-ice`)
- [x] Fonts managed via Home Manager `home.packages` (installed to `~/Library/Fonts/`)

### Remaining

- [ ] **Verify PATH ordering after full reboot** — current tmux sessions carry stale PATH from before nix-darwin. After reboot, confirm:
  - Nix paths (`/etc/profiles/per-user/jasper/bin`, `/run/current-system/sw/bin`) come before `/opt/homebrew/bin`
  - No duplicate PATH entries
  - `which claude` → Nix path
  - `which borders` → `/opt/homebrew/bin/borders`
  - NVM, luarocks, modular still work
  - If Homebrew is NOT in PATH after reboot, need to add `/opt/homebrew/bin` to PATH (for `borders` and `modular` formulas). Check if nix-darwin's `homebrew.enable` handles this automatically.
- [ ] **Add `borders` and `modular` to homebrew.brews** — these are DEFERRED Homebrew formulas with no nixpkgs equivalent
- [ ] **Manage macOS defaults** — Dock, Finder, keyboard settings (see inventory.md for audit)
- [ ] **Consider `homebrew.onActivation.cleanup = "zap"`** — once confident all casks/brews are declared
- [ ] **Update inventory.md** — mark migrated casks as MIGRATED
- [ ] **Commit and push all changes**

## Gotchas Discovered

- `services.nix-daemon.enable` was removed in nix-darwin — daemon is managed automatically when `nix.enable = true` (default)
- `nix.settings.auto-optimise-store` is blocked on macOS (corrupts store) — use `nix.optimise.automatic = true` instead
- `system.stateVersion` in nix-darwin is an integer (not a string like NixOS) — use `6` for fresh installs on 25.11
- `system.primaryUser` is required for `homebrew.enable` (nix-darwin multi-user migration)
- `users.users.jasper.home` must be set for Home Manager integration (HM derives `home.homeDirectory` from it)
- nix-darwin `master` branch moved to 26.05 — must pin to `nix-darwin-25.11` to match `nixpkgs-25.11-darwin`
- Ghostty nixpkg is Linux-only (`meta.platforms` does not include `aarch64-darwin`) — must stay as Homebrew cask
- nix-darwin's `set-environment` script (sourced from `/etc/zshenv`) sets the canonical PATH ordering: `~/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:...`
- Bootstrap requires `sudo` and `--extra-experimental-features "nix-command flakes"` after moving `/etc/nix/nix.conf`
- First bootstrap requires renaming `/etc/nix/nix.conf`, `/etc/bashrc`, `/etc/zshrc` to `*.before-nix-darwin`

## Reference

### Rebuild command
```bash
sudo darwin-rebuild switch --flake ~/.config/nix-config#mini
```

### Key files
- `flake.nix` — `darwinConfigurations.mini` entry point
- `hosts/mini/default.nix` — system config (nix settings, GC, homebrew, unfree, user)
- `users/jasper/darwin.nix` — HM darwin entry (packages incl. GUI apps, fonts, aerospace config)
- `users/jasper/common.nix` — shared HM config (zsh, tmux, git)
- `modules/nixpkgs.nix` — mergeable unfree/insecure package options

### Decisions made
See `docs/mini-transition/decisions.md` for:
- Pin nix-darwin to `nix-darwin-25.11` release branch

---

## Original Plan (kept for reference)

### Manage macOS Defaults

Add macOS preferences incrementally. Do a few at a time, rebuild, verify.

- [ ] Start with low-risk, easily visible settings:
  ```nix
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";  # list view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };
  ```
- [ ] Rebuild and verify. Some settings require `killall Dock` / `killall Finder` or logout.

### Finding the Right Default Keys

```bash
defaults read com.apple.dock autohide
defaults read > /tmp/before.txt
# (change setting in System Settings)
defaults read > /tmp/after.txt
diff /tmp/before.txt /tmp/after.txt
```

Check nix-darwin options: https://nix-darwin.github.io/nix-darwin/manual/

## Notes for Claude Code Agent

- **Start Homebrew cleanup as "none"** until the cask list is confirmed complete.
- macOS defaults are finicky. Apply them in small batches.
- Some `system.defaults` options require logout/reboot — warn the user.
- If `darwin-rebuild switch` fails, the previous generation is still active.
- nix-darwin options reference: https://nix-darwin.github.io/nix-darwin/manual/
- When adding casks, match the exact Homebrew cask name.
- The `set-environment` script at `/etc/zshenv` is the canonical PATH source — don't manually manage Nix PATH in zshrc.
- tmux inherits PATH from the shell that started it — always kill tmux server and relaunch after PATH changes to verify.

## Completion Criteria

- `darwin-rebuild switch` works and manages both system and user config
- GUI apps managed via Nix packages where possible, Homebrew casks only where necessary
- macOS defaults for key preferences are declared and applied
- Home Manager is integrated as a nix-darwin module (not standalone)
- PATH is clean — nix-darwin manages Nix paths, no manual PATH hacks in zshrc
- Homebrew only contains what nix-darwin tells it to
- All changes committed with descriptive conventional commits
- No regressions in daily workflow
