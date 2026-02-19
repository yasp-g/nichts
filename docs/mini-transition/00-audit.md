# Phase 0: Audit & Inventory

**Status:** `DONE`
**Prerequisites:** None
**Estimated time:** 1–2 sessions
**Outcome:** A clear picture of what's on the machine, what's needed, and what's clutter

## Why This Phase Matters

Every subsequent phase involves replacing or migrating something. If you don't know what you have, you'll either miss things (dropping functionality) or carry forward clutter you don't need. This phase is pure information gathering — nothing gets installed or removed.

## Checklist

### Homebrew Audit

- [x] Export formula list: `brew list --formula > ~/brew-formulas.txt`
- [x] Export cask list: `brew list --cask > ~/brew-casks.txt`
- [x] Export full dependency tree: `brew deps --tree --installed > ~/brew-deps-tree.txt`
- [x] Categorize each formula into: **KEEP** (actively use), **MAYBE** (might need), **REMOVE** (clutter)
- [x] Categorize each cask into: **KEEP**, **MAYBE**, **REMOVE**
- [x] Note which formulas are dependencies of other formulas (used `brew leaves` to identify top-level packages)
- [x] Run `brew autoremove` to drop orphaned dependencies
- [x] Run `brew cleanup --prune=all` to reclaim disk space (12 GB → 10 GB)
- [x] Save categorized lists to `reference/inventory.md`

### Dotfiles Audit

- [x] List all dotfiles/config dirs: `ls -la ~ | grep '^\.'` and `ls ~/.config/`
- [x] For each config file/dir, note: what app it belongs to, whether it's actively maintained, whether it's tracked in a repo
- [x] Identify configs with embedded secrets — `~/.gemini_aliases` had none; removed. No other secrets found in dotfiles.
- [x] Identify configs with machine-specific paths — only auto-generated files (firebase, copilot, MakerBot, octave); `~/.config/exercism/user.json` has hardcoded workspace path (fix in Phase 3)
- [x] Note which configs have Home Manager modules available
- [x] Save results to `reference/inventory.md`

### macOS Settings Audit

- [x] Document customized System Settings — key settings captured (Dock, Finder, key repeat); full pane-by-pane review deferred to Phase 4 when nix-darwin defaults are configured
- [x] Key areas checked: Dock (autohide on, bottom, show-recents on), Finder (extensions, path bar, status bar all on), Keyboard (using system defaults — will set explicitly in Phase 4)
- [x] Export current defaults: `defaults read > ~/macos-defaults-full.txt` (134k lines, saved as reference)
- [x] Identify which settings matter enough to manage declaratively — documented in `reference/inventory.md`
- [x] Save results to `reference/inventory.md`

### Application Inventory

- [x] List `/Applications/` contents: `ls /Applications/`
- [x] List `~/Applications/` contents — does not exist
- [x] For each app, note installation method: Mac App Store, Homebrew Cask, direct download, other
- [x] Categorize each app: **KEEP**, **MAYBE**, **REMOVE** — all resolved, no MAYBEs remaining
- [x] Note apps with significant local data — Pokemon Reborn saves in `~/Library/Application Support/Pokemon Reborn/` (safe from reinstall; game is a manual install, not Nix-manageable). All other KEEPs are cloud-synced or have rebuildable data.
- [x] Save results to `reference/inventory.md`

### Data & Disk Audit

- [x] Check overall disk usage: 460 GiB total, 15 GiB used, 36 GiB available
- [x] Check large directories — documented in `reference/inventory.md`
- [x] Check `~/Library/Caches` size: 10 GB (down from 12 GB after cleanup)
- [x] Identify any data that should be backed up — all app data either cloud-synced or rebuildable; Pokemon Reborn saves are safe in Application Support
- [x] Clean out obvious junk — `brew autoremove && brew cleanup --prune=all` run
- [x] Verify Time Machine backups — backup started 2026-02-19

### Shell Environment Audit

- [x] Note current shell: `/bin/zsh` (system zsh)
- [x] Document PATH — entries documented in `reference/inventory.md`; PATH from .zshrc includes tfenv (being removed), luarocks, modular, NVM
- [x] List shell plugins/frameworks — none (no oh-my-zsh); Powerlevel10k prompt, FZF integration
- [x] List active shell aliases and functions — only zsh defaults; no custom aliases or functions
- [x] Note any custom completions — none user-written; `zsh-completions` via Homebrew (DEFERRED to Phase 3)
- [x] Document environment variables — MODULAR_HOME, NVM_DIR, HOMEBREW_* documented in `reference/inventory.md`

## Notes for Claude Code Agent

- This phase is read-only. Do not install, remove, or modify anything.
- Run audit commands and help the user categorize results.
- Save all outputs to `reference/inventory.md` in structured sections.
- Flag anything that looks like it will be tricky to migrate (unusual packages, complex configs, embedded secrets).
- If the user isn't sure about a package/app, mark it as MAYBE — it can be resolved later.

## Completion Criteria

- All checklist items are done
- `reference/inventory.md` is populated with categorized lists
- User has reviewed and confirmed the categorizations
- No open questions about what's on the machine
