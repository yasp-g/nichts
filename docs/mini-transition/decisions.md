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
**Date:** TBD
**Phase:** 3
**Decision:** TBD
**Alternatives considered:** env file sourced by shell, agenix, sops-nix, macOS Keychain
**Rationale:** TBD

### Consolidate Terraform/OpenTofu Version Managers to tenv
**Date:** 2026-02-18
**Phase:** 0 (decided), 2 (implemented)
**Decision:** Replace `tfenv`, `tofuenv`, and `tfswitch` with `tenv`
**Alternatives considered:** Keep one of the existing three; manage specific Terraform versions via Nix overlays
**Rationale:** All three tools were installed simultaneously, creating redundancy. `tenv` handles both Terraform and OpenTofu in one tool and is available in nixpkgs, making it the clean declarative choice.

---

*Add new decisions above this line.*
