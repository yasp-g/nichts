# Nix Transition Roadmap — macOS Apple Silicon Mac Mini

## Overarching Goals

1. **Declarative package and configuration management** via Nix, Home Manager, and nix-darwin
2. **Clean out clutter** — every phase is an opportunity to audit and remove what's not needed
3. **Never drop functionality** — nothing gets removed until its replacement is confirmed working
4. **Never lose data** — audit and back up before every destructive operation
5. **Consistency across machines** — shared config with the existing NixOS MacBook Pro

## Architecture Overview

```
┌─────────────────────────────────────────────┐
│              nix-darwin                      │
│  (macOS defaults, system env, services,     │
│   Homebrew Cask declarations, fonts)        │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │          Home Manager                 │  │
│  │  (dotfiles, shell config, editor      │  │
│  │   settings, user-level packages)      │  │
│  └───────────────────────────────────────┘  │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │        Nix Package Manager            │  │
│  │  (CLI tools, libraries, /nix/store)   │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

Each layer is independent but composable. Adopt them bottom-up, one at a time.

## Phases

| Phase | Name | Status | Guide |
|-------|------|--------|-------|
| 0 | Audit & Inventory | `IN_PROGRESS` | [phases/00-audit.md](phases/00-audit.md) |
| 1 | Install Nix | `NOT_STARTED` | [phases/01-install-nix.md](phases/01-install-nix.md) |
| 2 | Migrate CLI Packages | `NOT_STARTED` | [phases/02-migrate-cli.md](phases/02-migrate-cli.md) |
| 3 | Set Up Home Manager | `NOT_STARTED` | [phases/03-home-manager.md](phases/03-home-manager.md) |
| 4 | Introduce nix-darwin | `NOT_STARTED` | [phases/04-nix-darwin.md](phases/04-nix-darwin.md) |
| 5 | Multi-Machine Consolidation | `NOT_STARTED` | [phases/05-consolidation.md](phases/05-consolidation.md) |

## Reference Docs

- [reference/decisions.md](reference/decisions.md) — Architecture decisions log
- [reference/inventory.md](reference/inventory.md) — Template for audit results
- [reference/troubleshooting.md](reference/troubleshooting.md) — Common issues and fixes
- [reference/rollback.md](reference/rollback.md) — How to undo things safely

## Rules for the Claude Code Agent

1. **Read the relevant phase guide before starting work.** Check the status and prerequisites.
2. **Never remove a package/config until its replacement is verified working.** The pattern is always: install new → verify → remove old → commit.
3. **Commit after every meaningful change.** Use conventional commits: `feat:` for new capabilities, `chore:` for maintenance, `refactor:` for restructuring.
4. **Update checklist status in the phase guide** after completing each step.
5. **Log decisions in `reference/decisions.md`** when making non-obvious choices.
6. **Ask before destructive operations.** If a step removes something or modifies system state, confirm with the user first.
7. **Test after every change.** Open a new shell, verify PATH, verify the tool works, verify configs load.
8. **Back up before overwriting.** If replacing a dotfile, copy the original to `~/.config-backup/` or similar first.

## Progress Tracking

Update the status column in the phase table above as work progresses:
- `NOT_STARTED` — Haven't begun
- `IN_PROGRESS` — Actively working on it
- `BLOCKED` — Waiting on something (note what in the phase guide)
- `DONE` — All checklist items complete and verified
