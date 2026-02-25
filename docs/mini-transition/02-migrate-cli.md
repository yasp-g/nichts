# Phase 2: Set Up Home Manager & Migrate CLI Packages

**Status:** `IN_PROGRESS`
**Prerequisites:** Phase 1 complete, `reference/inventory.md` has categorized Homebrew formulas
**Estimated time:** 2–4 sessions
**Outcome:** Standalone Home Manager running on the Mac mini, all KEEP CLI tools declared in `home.packages`, corresponding Homebrew formulas removed

## Overview

This phase combines two things that were originally separate:

1. **Set up standalone Home Manager** — add a `homeConfigurations` output to the flake and create a Mac-mini-specific home file
2. **Migrate CLI packages declaratively** — add packages to `home.packages` instead of using throwaway `nix profile install` commands

The package list you build here carries forward unchanged into Phase 4 (nix-darwin). The only thing that changes later is *how* it's activated — from `home-manager switch` to `darwin-rebuild switch`.

### Why not `nix profile install`?

The original plan was to migrate imperatively with `nix profile install`, then redo the work declaratively in Phase 3. Since the flake already has Home Manager wired up, the extra setup is minimal and all work done here is permanent.

## Part 1: Set Up Standalone Home Manager

### Add a homeConfigurations Output to the Flake

- [x] Create `users/jasper/darwin.nix` (macOS Home Manager config, imports `common.nix`)
- [x] Create `users/jasper/common.nix` (shared config across all machines)
- [x] Restructure `users/jasper/`: renamed `home.nix` → `nixos.nix`, moved desktop configs to `hyprland/` and shared configs to `common/`
- [x] Add `homeConfigurations.jasper` output to `flake.nix` using `nixpkgs-darwin`
- [x] Add `nixpkgs-darwin` input (`nixpkgs-25.11-darwin`) for macOS binary cache coverage
- [x] `git add` and commit
- [x] Build and activate: `nix run home-manager -- switch --flake ~/.config/nix-config#jasper`
- [x] Verify: `home-manager --version` — 25.11-pre
- [x] Verify: existing tools still work, PATH is not broken
- [x] Verify: NixOS (mbp2015) rebuilds successfully with new file structure

### Important Notes

- **Do NOT enable `programs.zsh` or any dotfile management yet.** This phase is packages only. Dotfiles are Phase 3.
- The NixOS config is at `users/jasper/nixos.nix`. Don't modify it during this phase.
- If the flake eval fails, nothing is broken — your existing tools are unaffected. Fix the Nix expression and retry.

## Part 2: Migrate CLI Packages

### Strategy

Migrate in small batches (5–10 packages). The pattern for each batch:

```
1. Add packages to home.packages in darwin.nix
2. Rebuild: home-manager switch --flake ~/.config/nix-config#jasper
3. Open a new terminal
4. Verify each package works (which, --version, basic usage)
5. Uninstall corresponding Homebrew formulas
6. Verify again in a new shell
7. Commit
```

**Never skip verification steps.**

### Pre-Work

- [x] Review the KEEP list from `reference/inventory.md`
- [x] For each KEEP package, verify it exists in nixpkgs (all 29 KEEP packages confirmed available)
- [x] Note any packages that don't exist in nixpkgs or have different names:
  - `kubernetes-cli` (brew) → `kubectl` (nix)
  - `trash` (brew) → `trash-cli` (nix)
  - `haskell-stack` (brew) → `stack` (nix)

### Migration Batches

#### Batch 1 — 2026-02-25

| Package | Nix name | Added to home | Verified | Brew removed | Final check |
|---------|----------|---------------|----------|--------------|-------------|
| git | `git` | ✅ | ✅ | ✅ | ✅ |
| neovim | `neovim` | ✅ | ✅ | ✅ | ✅ |
| fzf | `fzf` | ✅ | ✅ | ✅ | ✅ |
| tree | `tree` | ✅ | ✅ | ✅ | ✅ |
| tmux | `tmux` | ✅ | ✅ | ✅ | ✅ |
| rsync | `rsync` | ✅ | ✅ | ✅ | ✅ |
| fastfetch | `fastfetch` | ✅ | ✅ | ✅ | ✅ |

Also auto-removed 10 orphaned Homebrew deps (libiconv, lpeg, luajit, luv, popt, tree-sitter@0.25, unibilium, utf8proc, xxhash, yyjson).

#### Batch 2 — 2026-02-25

| Package | Nix name | Added to home | Verified | Brew removed | Final check |
|---------|----------|---------------|----------|--------------|-------------|
| chafa | `chafa` | ✅ | ✅ | ✅ | ✅ |
| ffmpeg | `ffmpeg` | ✅ | ✅ | ✅ | ✅ |
| glow | `glow` | ✅ | ✅ | ✅ | ✅ |
| gnupg | `gnupg` | ✅ | ✅ | ✅ | ✅ |
| imagemagick | `imagemagick` | ✅ | ✅ | ✅ | ✅ |
| jp2a | — | ❌ broken on aarch64-darwin | — | ✅ removed | — |
| kubernetes-cli | `kubectl` | ✅ | ✅ | ✅ | ✅ |
| opencode | `opencode` | ✅ | ✅ | ✅ | ✅ |
| tenv | `tenv` | ✅ | ✅ | ✅ | ✅ |
| trash | `trash-cli` | ✅ | ✅ | ✅ | ✅ |
| uv | `uv` | ✅ | ✅ | ✅ | ✅ |
| yazi | `yazi` | ✅ | ✅ | ✅ | ✅ |

Auto-removed 61 orphaned Homebrew deps.

#### Batch 3 — 2026-02-25

| Package | Nix name | Added to home | Verified | Brew removed | Final check |
|---------|----------|---------------|----------|--------------|-------------|
| cabal-install | `cabal-install` | ✅ | ✅ | ✅ | ✅ |
| cmake | `cmake` | ✅ | ✅ | ✅ | ✅ |
| exercism | `exercism` | ✅ | ✅ | ✅ | ✅ |
| git-filter-repo | `git-filter-repo` | ✅ | ✅ | ✅ | ✅ |
| haskell-language-server | `haskell-language-server` | ✅ | ✅ | ✅ | ✅ |
| haskell-stack | `stack` | ✅ | ✅ | ✅ | ✅ |
| luarocks | `luarocks` | ✅ | ✅ | ✅ | ✅ |
| lynx | `lynx` | ✅ | ✅ | ✅ | ✅ |
| pandoc | `pandoc` | ✅ | ✅ | ✅ | ✅ |
| wireshark | `wireshark` | ✅ | ✅ | ✅ | ✅ |

Auto-removed 16 orphaned Homebrew deps.

#### Batch Template

**Steps:**

- [ ] Add packages to `home.packages` in `darwin.nix`
- [ ] Rebuild: `home-manager switch --flake ~/.config/nix-config#jasper`
- [ ] For each package:
  - [ ] `which <command>` — should show a `/nix/store/...` path
  - [ ] `<command> --version` — should work
  - [ ] Quick functional test
- [ ] `brew uninstall <formula>` for each migrated package
- [ ] Open new terminal, verify everything still works
- [ ] `brew autoremove` to clean orphaned dependencies
- [ ] Commit

### Packages That Need Special Attention

#### Different names between Homebrew and nixpkgs
- `kubernetes-cli` (brew) → `kubectl` (nix)
- `trash` (brew) → `trash-cli` (nix)
- Other name differences may exist — always check with `nix search`

#### Packages with no nixpkgs equivalent
For packages that genuinely don't exist in nixpkgs:
1. Keep them in Homebrew (managed declaratively via nix-darwin in Phase 4)
2. Write a custom Nix derivation (advanced, save for later)
3. Reconsider if you actually need the package

Log these in `reference/decisions.md`.

#### Packages that install shell completions
Some tools install completions (for zsh, bash, etc.). Completions may break after switching to the Nix version. Note any issues — they'll be fixed properly in Phase 3 when Home Manager manages shell config.

#### Packages that need to compile from source
Most nixpkgs packages are pre-built. If `home-manager switch` starts compiling from source, something is off. Check:
```bash
nix path-info --store https://cache.nixos.org nixpkgs#<package>
```

### Packages to NOT Migrate Yet

- **GUI applications** — Stay in Homebrew Cask, managed declaratively in Phase 4
- **Shell itself** (zsh) — macOS ships zsh; Nix-managing your shell is Phase 3
- **Powerlevel10k** — Deferred to Phase 3 (Home Manager `programs.zsh`)
- **zsh-completions** — Deferred to Phase 3
- **Anything with complex system integration** — handled in Phase 4 via nix-darwin
- **`felixkratz/formulae/borders`** — No nixpkgs equivalent; stays in Homebrew
- **`modularml/packages/modular`** — No nixpkgs equivalent; stays in Homebrew

## Part 3: Clean Up REMOVE Packages

After CLI migration is complete, uninstall packages marked REMOVE in the inventory:

- [x] `brew uninstall aha bind boost curl llvm tbb telnet tfenv tofuenv`
- [x] `brew uninstall hashicorp/tap/terraform && brew untap hashicorp/tap`
- [x] `brew uninstall warrensbox/tap/tfswitch && brew untap warrensbox/tap`
- [x] `brew uninstall jq ghc lua grep` (leftover leaves not in KEEP list)
- [x] `brew autoremove`
- [x] `brew cleanup --prune=all`

## Progress Tracking

- Total Homebrew formula leaves remaining: 4 (borders, modular, powerlevel10k, zsh-completions — all DEFERRED)
- Total Home Manager packages: 29
- Packages deferred: borders (no nixpkgs), modular (no nixpkgs), powerlevel10k (Phase 3), zsh-completions (Phase 3)
- Packages dropped: jp2a (broken on aarch64-darwin, not needed)

## Notes for Claude Code Agent

- **Always open a new terminal** (or `exec $SHELL`) after rebuilding or removing packages.
- If `which` shows a Homebrew path after rebuilding, it's a PATH ordering issue — do not edit PATH manually; note it for investigation.
- If a package behaves differently (different flags, missing features), check version: `nix eval nixpkgs#<pkg>.version` vs `brew info <pkg>`.
- Do not rush. Better to migrate 5 packages correctly than 50 with subtle breakage.
- After removing Homebrew formulas, run `brew autoremove` to clean up orphaned deps.
- If `home-manager switch` fails, the previous generation is still active. Debug the Nix expression — don't fall back to imperative installs.
- **Do not enable any HM program modules** (like `programs.git`, `programs.zsh`) in this phase. Only use `home.packages`. Dotfile management is Phase 3.
- Track everything in the batch checklist above.

## Completion Criteria

- Standalone Home Manager is functional via the flake
- All KEEP CLI packages from the audit are declared in `home.packages`
- Corresponding Homebrew formulas are uninstalled
- REMOVE packages are uninstalled
- `brew list --formula` shows only: packages deferred to Phase 4, dependencies of remaining casks, packages with no nixpkgs equivalent
- All migrated tools verified working in a clean shell
- No regressions in daily workflow
