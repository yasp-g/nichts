# Phase 2: Migrate CLI Packages from Homebrew to Nix

**Status:** `NOT_STARTED`
**Prerequisites:** Phase 1 complete, `reference/inventory.md` has categorized Homebrew formulas
**Estimated time:** 2–4 sessions (do in batches, not all at once)
**Outcome:** All KEEP CLI tools installed via Nix, corresponding Homebrew formulas removed

## Strategy

Migrate in small batches (5–10 packages per session). The pattern for every single package is:

```
1. Install via Nix
2. Verify it works (version, basic usage, completions)
3. Confirm it takes precedence over Homebrew version (check PATH)
4. Uninstall Homebrew version
5. Verify again in a new shell
6. Commit
```

**Never skip step 2 or step 5.**

## Pre-Work

- [ ] Review the KEEP list from `reference/inventory.md`
- [ ] For each KEEP package, verify it exists in nixpkgs:
  ```bash
  nix search nixpkgs <package-name>
  ```
- [ ] Note any packages that don't exist in nixpkgs or have different names (log in decisions.md)
- [ ] Decide on management approach — there are two paths:

### Approach A: Imperative (nix profile) — Simpler, Less Declarative

```bash
nix profile install nixpkgs#ripgrep
```

Pros: Familiar, quick. Cons: Not tracked in config, not reproducible across machines.

### Approach B: Declarative (Home Manager or flake devShell) — Recommended

Packages are listed in your nix config and installed via `home-manager switch` or a flake.
This is set up in Phase 3, but you can start building the package list now.

**Recommended hybrid:** Use `nix profile install` for immediate migration, then move the
package list into Home Manager in Phase 3. The important thing now is getting off Homebrew.

## Migration Checklist Template

For each batch, copy this template:

### Batch N — [Date]

| Package | In nixpkgs? | Nix name | Installed | Verified | Brew removed | Final check |
|---------|-------------|----------|-----------|----------|--------------|-------------|
| example | ✅ | `example` | ☐ | ☐ | ☐ | ☐ |

**Steps for each package:**

- [ ] `nix profile install nixpkgs#<name>`
- [ ] Open new terminal
- [ ] `which <command>` — should show `/nix/...` path
- [ ] `<command> --version` — should work
- [ ] Test basic functionality (run a real command you'd normally use)
- [ ] `brew uninstall <name>`
- [ ] Open new terminal again
- [ ] `which <command>` — should still show `/nix/...` path
- [ ] `<command> --version` — should still work

After each batch:
- [ ] `brew autoremove` to clean orphaned dependencies
- [ ] Commit any config changes

## Packages That Need Special Attention

### Different names between Homebrew and nixpkgs
Some packages have different names. Common examples:
- `gnu-sed` (brew) → `gnused` (nix)
- `grep` (brew GNU grep) → `gnugrep` (nix)
- `make` (brew GNU make) → `gnumake` (nix)
- `findutils` (brew) → `findutils` (nix, but `gfind` vs `find` behavior may differ)

Always verify the actual binary name and behavior after installing the Nix version.

### Packages that install shell completions
Some tools install completions (for zsh, bash, etc.). Verify completions still work after switching to the Nix version. If they break, they'll be fixed properly in Phase 3 when Home Manager manages shell config.

### Packages that need to compile from source
Most nixpkgs packages are pre-built via Hydra's binary cache. If `nix profile install` starts compiling from source, something is off — likely a different system architecture or a package not in the cache. Check:
```bash
nix path-info --store https://cache.nixos.org nixpkgs#<package>
```

### Packages with no nixpkgs equivalent
For packages that genuinely don't exist in nixpkgs, options are:
1. Keep them in Homebrew (will be managed declaratively via nix-darwin in Phase 4)
2. Write a custom Nix derivation (advanced, save for later)
3. Reconsider if you actually need the package

Log these in `reference/decisions.md`.

## Packages to NOT Migrate Yet

- **GUI applications** — Stay in Homebrew Cask, managed declaratively in Phase 4
- **Shell itself** (zsh) — macOS ships zsh; Nix-managing your shell requires careful handling, done in Phase 3
- **Anything with complex system integration** (e.g., `dnsmasq`, `nginx` if used as a service) — handled in Phase 4 via nix-darwin services

## Progress Tracking

After each session, update:
- [ ] Total Homebrew formulas remaining: ___
- [ ] Total Nix profile packages: ___
- [ ] Any packages deferred or problematic: ___

## Notes for Claude Code Agent

- Always open a new terminal (or `exec $SHELL`) after installing/removing packages.
- If `which` shows a Homebrew path after installing the Nix version, it's a PATH ordering issue — do not edit PATH manually; note it for investigation.
- If a package behaves differently (different flags, missing features), it may be a version difference. Check `nix eval nixpkgs#<pkg>.version` vs `brew info <pkg>`.
- Do not rush. It is better to migrate 5 packages correctly than 50 packages with subtle breakage.
- After removing Homebrew formulas, run `brew autoremove` to clean up orphaned deps.
- Track everything in the batch checklist above.

## Completion Criteria

- All KEEP CLI packages from the audit are installed via Nix
- Corresponding Homebrew formulas are uninstalled
- `brew list --formula` shows only: packages deferred to Phase 4, dependencies of remaining casks, packages with no nixpkgs equivalent
- All migrated tools verified working in a clean shell
- No regressions in daily workflow
