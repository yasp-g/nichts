# Architecture Decisions Log

Record non-obvious choices made during the Nix transition. This helps future-you (and the Claude Code agent) understand WHY things are set up a certain way.

## Format

```
### [Short Title]
**Date:** YYYY-MM-DD
**Phase:** N
**Decision:** What was decided
**Alternatives considered:** What else was on the table
**Rationale:** Why this choice was made
```

---

## Decisions

### Use Determinate Systems Installer
**Date:** TBD
**Phase:** 1
**Decision:** Use `nix-installer` from Determinate Systems rather than the official Nix installer
**Alternatives considered:** Official Nix installer from nixos.org
**Rationale:** Cleaner Apple Silicon support, enables flakes by default, provides reliable uninstall path, handles APFS volume creation correctly.

### Use Flakes from the Start
**Date:** TBD
**Phase:** 1
**Decision:** Use flakes for the Mac mini config, even though the NixOS MacBook Pro uses channels
**Alternatives considered:** Use channels on Mac mini too, migrate both to flakes later
**Rationale:** Starting fresh on Mac mini is the ideal time to adopt flakes. Pinned inputs via flake.lock, standard interface for nix-darwin and Home Manager, eventual consolidation into a multi-machine flake. NixOS machine migrates to flakes in Phase 5.

### Secrets Approach
**Date:** 2026-02-26
**Phase:** 3
**Decision:** No action needed for now. No secrets were found in migrated dotfiles. gh auth tokens are in the macOS Keychain, SSH keys are in `~/.ssh/` (gitignored). If secrets are needed in Nix config later, start with a sourced env file (`source ~/.secrets` in `initExtra`) and consider agenix/sops-nix in Phase 5.
**Alternatives considered:** env file sourced by shell, agenix, sops-nix, macOS Keychain
**Rationale:** No dotfiles contained secrets, so no migration was required. Deferring a full secrets framework avoids unnecessary complexity.

### Consolidate Terraform/OpenTofu Version Managers to tenv
**Date:** 2026-02-18
**Phase:** 0 (decided), 2 (implemented)
**Decision:** Replace `tfenv`, `tofuenv`, and `tfswitch` with `tenv`
**Alternatives considered:** Keep one of the existing three; manage specific Terraform versions via Nix overlays
**Rationale:** All three tools were installed simultaneously, creating redundancy. `tenv` handles both Terraform and OpenTofu in one tool and is available in nixpkgs, making it the clean declarative choice.

### Manually Enable Experimental Features in nix.conf
**Date:** 2026-02-25
**Phase:** 1
**Decision:** Manually added `experimental-features = nix-command flakes` to `/etc/nix/nix.conf`
**Alternatives considered:** Reinstalling with different installer options
**Rationale:** The Determinate installer (Nix 2.33.3) did not enable `nix-command` and `flakes` by default in `nix.conf`, only setting `build-users-group = nixbld`. The new `nix shell` / `nix search` commands require these features. This will be managed by nix-darwin in Phase 4.

### Separate nixpkgs Inputs for NixOS and Darwin
**Date:** 2026-02-25
**Phase:** 2
**Decision:** Use two nixpkgs inputs: `nixpkgs` (`nixos-25.11`) for the NixOS machine and `nixpkgs-darwin` (`nixpkgs-25.11-darwin`) for macOS Home Manager and nix-darwin.
**Alternatives considered:** Single `nixpkgs-unstable` for everything; single `nixos-25.11` for everything
**Rationale:** The `nixos-25.11` branch doesn't have pre-built binaries for aarch64-darwin in the binary cache. Using it on macOS causes packages (e.g., `inetutils`) to compile from source, which can fail. The `nixpkgs-25.11-darwin` branch has darwin binaries cached by Hydra. Using `nixpkgs-unstable` everywhere would work but puts the NixOS machine on a rolling release, risking unexpected breakage on `nix flake update`. Two inputs keeps both machines on stable 25.11 with proper binary cache coverage.

### Skip Imperative nix profile — Go Straight to Home Manager
**Date:** 2026-02-25
**Phase:** 2
**Decision:** Set up standalone Home Manager in Phase 2 and migrate CLI packages directly into `home.packages`, rather than using `nix profile install` as a throwaway intermediate step.
**Alternatives considered:** Imperative migration with `nix profile install` in Phase 2, then move packages into Home Manager in Phase 3
**Rationale:** The flake already has `home-manager` as an input. The package list (`home.packages = [ ... ]`) is identical whether Home Manager runs standalone or inside nix-darwin, so all work is permanent. The only downside is needing a working HM config before migrating packages, but the setup is minimal. Avoids doing the same work twice.

### Drop nbdime Git Integration (For Now)
**Date:** 2026-02-25
**Phase:** 3
**Decision:** Remove the nbdime Jupyter notebook diff/merge driver entries from `.gitconfig` rather than carrying them into the Home Manager `programs.git` config.
**Alternatives considered:** Keep the entries in `extraConfig` even though nbdime isn't installed
**Rationale:** `nbdime` isn't currently installed, so the entries (`git-nbdiffdriver`, `git-nbmergedriver`, `git-nbdifftool`, `git-nbmergetool`) are inert. Dropping them keeps the config clean. If Jupyter notebook diffing is needed again, add `nbdime` as a package and re-add the git config entries together in one step.

### Neovim: xdg.configFile + home.packages, Not programs.neovim
**Date:** 2026-02-25
**Phase:** 3
**Decision:** Manage neovim config with `xdg.configFile` and keep `neovim` in `home.packages`, rather than using the `programs.neovim` HM module. `lazy-lock.json` is excluded from the repo — lazy.nvim generates it at runtime.
**Alternatives considered:** `programs.neovim` with `extraLuaConfig` or wrapping plugins via Nix
**Rationale:** The existing config is a full Lua setup with lazy.nvim managing plugins. `programs.neovim` adds the neovim package itself, which conflicts with the one in `home.packages`. It also encourages Nix-wrapped plugin management, which doesn't fit a lazy.nvim workflow. Simpler to just symlink the Lua files and let lazy.nvim handle plugins. `lazy-lock.json` is a runtime artifact (plugin lock file) that lazy.nvim creates and updates automatically; committing it would cause unnecessary churn.

---

*Add new decisions above this line.*
