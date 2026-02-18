# Phase 0: Audit & Inventory

**Status:** `NOT_STARTED`
**Prerequisites:** None
**Estimated time:** 1–2 sessions
**Outcome:** A clear picture of what's on the machine, what's needed, and what's clutter

## Why This Phase Matters

Every subsequent phase involves replacing or migrating something. If you don't know what you have, you'll either miss things (dropping functionality) or carry forward clutter you don't need. This phase is pure information gathering — nothing gets installed or removed.

## Checklist

### Homebrew Audit

- [ ] Export formula list: `brew list --formula > ~/brew-formulas.txt`
- [ ] Export cask list: `brew list --cask > ~/brew-casks.txt`
- [ ] Export full dependency tree: `brew deps --tree --installed > ~/brew-deps-tree.txt`
- [ ] Categorize each formula into: **KEEP** (actively use), **MAYBE** (might need), **REMOVE** (clutter)
- [ ] Categorize each cask into: **KEEP**, **MAYBE**, **REMOVE**
- [ ] Note which formulas are dependencies of other formulas (don't remove a dep you still need)
- [ ] Run `brew autoremove` to drop orphaned dependencies
- [ ] Run `brew cleanup --prune=all` to reclaim disk space
- [ ] Save categorized lists to `reference/inventory.md`

### Dotfiles Audit

- [ ] List all dotfiles/config dirs: `ls -la ~ | grep '^\.'` and `ls ~/.config/`
- [ ] For each config file/dir, note: what app it belongs to, whether it's actively maintained, whether it's tracked in a repo
- [ ] Identify configs with embedded secrets (API keys, tokens, passwords)
- [ ] Identify configs with machine-specific paths (hardcoded `/Users/yasp/...` etc.)
- [ ] Note which configs have Home Manager modules available (check https://nix-community.github.io/home-manager/options.xhtml)
- [ ] Save results to `reference/inventory.md`

### macOS Settings Audit

- [ ] Document customized System Settings (go through each pane and note what you've changed)
- [ ] Key areas to check: Dock & Menu Bar, Keyboard (key repeat, shortcuts), Trackpad, Finder preferences, Desktop & Screensaver, Accessibility settings, Security & Privacy
- [ ] Export current defaults where possible: `defaults read > ~/macos-defaults-full.txt` (large file, but useful reference)
- [ ] Identify which settings matter enough to manage declaratively
- [ ] Save results to `reference/inventory.md`

### Application Inventory

- [ ] List `/Applications/` contents: `ls /Applications/`
- [ ] List `~/Applications/` contents if it exists
- [ ] For each app, note installation method: Mac App Store, Homebrew Cask, direct download, other
- [ ] Categorize each app: **KEEP**, **MAYBE**, **REMOVE**
- [ ] Note any apps with significant local data/config you'd lose if reinstalled
- [ ] Save results to `reference/inventory.md`

### Data & Disk Audit

- [ ] Check overall disk usage: `df -h /`
- [ ] Check large directories: `du -sh ~/Desktop ~/Documents ~/Downloads ~/Library ~/Movies ~/Music ~/Pictures 2>/dev/null`
- [ ] Check `~/Library/Caches` size: `du -sh ~/Library/Caches`
- [ ] Identify any data that should be backed up before proceeding
- [ ] Clean out obvious junk (old downloads, cache bloat, etc.)
- [ ] Verify Time Machine or other backups are current

### Shell Environment Audit

- [ ] Note current shell: `echo $SHELL`
- [ ] Document PATH: `echo $PATH | tr ':' '\n'`
- [ ] List shell plugins/frameworks (oh-my-zsh, starship, etc.)
- [ ] List active shell aliases and functions: `alias` and `functions` (zsh) or `declare -f` (bash)
- [ ] Note any custom completions
- [ ] Document environment variables that matter: `env | sort`

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
