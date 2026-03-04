# Phase 5: Multi-Machine Consolidation

**Status:** `IN_PROGRESS`
**Prerequisites:** Phase 4 complete, NixOS MacBook Pro config available
**Outcome:** Single flake repo managing both machines with shared modules

## Overview

This phase brings your NixOS MacBook Pro config into the same flake as your Mac mini's nix-darwin config. Shared Home Manager modules (git, shell, editor) are factored out so both machines stay consistent. Machine-specific config stays in separate host directories.

## Current Progress (2026-03-04)

### Already Done
- [x] NixOS MacBook Pro already in the flake (`nixosConfigurations.mbp2015`)
- [x] Shared packages consolidated into `users/jasper/common.nix`
- [x] Darwin-specific packages in `users/jasper/darwin.nix`
- [x] NixOS-specific packages in `modules/core/default.nix`
- [x] Removed duplicate packages from `modules/core` (now in common.nix via Home Manager)

### Remaining
- [ ] Test rebuild on mbp2015 to verify shared config works
- [ ] Handle any platform-specific issues discovered during testing
- [ ] macOS defaults (deferred from Phase 4)

## Target Repository Structure

```
nix-config/
├── flake.nix                    # Top-level flake with all machine outputs
├── flake.lock
├── modules/
│   ├── home/                    # Shared Home Manager modules
│   │   ├── default.nix          # Common imports
│   │   ├── git.nix
│   │   ├── shell.nix
│   │   ├── editor.nix
│   │   └── ...
│   ├── darwin/                  # Shared nix-darwin modules (if needed)
│   └── nixos/                   # Shared NixOS modules (if needed)
├── hosts/
│   ├── mac-mini/
│   │   ├── configuration.nix    # nix-darwin system config
│   │   └── home.nix             # Mac-mini-specific Home Manager overrides
│   └── macbook-pro/
│       ├── configuration.nix    # NixOS system config
│       ├── hardware-configuration.nix
│       └── home.nix             # MacBook-specific Home Manager overrides
└── reference/                   # Transition docs (this guide)
```

## Checklist

### Migrate NixOS Config to Flakes

~~Your MacBook Pro currently uses channels.~~ **ALREADY DONE** — mbp2015 is already in the flake.

- [x] NixOS config in `hosts/mbp2015/`
- [x] `nixosConfigurations.mbp2015` in `flake.nix`
- [ ] Test rebuild after package consolidation: `sudo nixos-rebuild switch --flake .#mbp2015`
- [ ] Verify no regressions

### Factor Out Shared Home Manager Modules

**DONE** — Packages consolidated into `users/jasper/common.nix`:

- [x] Shared CLI tools (git, neovim, fzf, ripgrep, etc.)
- [x] Shared GUI apps (claude-code, obsidian, vscode, discord, zed-editor)
- [x] Shared fonts (nerd-fonts.meslo-lg)
- [x] Darwin-only packages stay in `darwin.nix`
- [x] NixOS-only packages stay in `modules/core/default.nix`

Current structure:
```
users/jasper/
├── common.nix      # Shared packages + program configs (zsh, git, tmux, etc.)
├── darwin.nix      # Darwin-only (aerospace, google-chrome, etc.) + imports common.nix
└── nixos.nix       # NixOS-only (Hyprland configs) + imports common.nix
```

~~- [ ] Extract into `modules/home/`:~~
  ```nix
  # modules/home/git.nix
  { config, pkgs, ... }:
  {
    programs.git = {
      enable = true;
      userName = "Your Name";
      userEmail = "your@email.com";
      # ... shared settings
    };
  }
  ```
- [ ] Create `modules/home/default.nix` that imports all shared modules:
  ```nix
  { ... }:
  {
    imports = [
      ./git.nix
      ./shell.nix
      ./editor.nix
    ];
  }
  ```
- [ ] Reference shared modules from each host's `home.nix`:
  ```nix
  # hosts/mac-mini/home.nix
  { ... }:
  {
    imports = [ ../../modules/home ];

    # Mac-mini-specific overrides here
  }
  ```
- [ ] Rebuild both machines, verify no regressions
- [ ] Commit

### Handle Platform Differences

Some config is platform-conditional:
```nix
# In a shared module
{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fd
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-only packages
    hyprlock
    waybar
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-only packages
    # (if any)
  ];
}
```

- [ ] Identify platform-specific config in shared modules
- [ ] Use `lib.optionals` or `lib.mkIf` for conditional inclusion
- [ ] Test on both platforms

### Keyboard Consistency Verification

- [ ] Verify your Ctrl/Super swap on Hyprland still works with the new config structure
- [ ] Verify the corresponding physical key positions on macOS produce equivalent shortcuts
- [ ] Document any remaining inconsistencies in `reference/decisions.md`

### Secrets Management (If Needed)

If you need encrypted secrets in the repo (API keys, etc.):

- [ ] Evaluate agenix vs sops-nix
- [ ] Set up chosen solution
- [ ] Migrate secrets from `~/.secrets` files to encrypted repo storage
- [ ] Test on both machines
- [ ] Log decision in `reference/decisions.md`

## Notes for Claude Code Agent

- This phase involves working on two machines. Changes to shared modules need to be tested on both.
- The NixOS channel-to-flake migration can be tricky — `nix flake check` is your friend for catching errors before switching.
- Be especially careful with the MacBook Pro's hardware-configuration.nix — it must stay machine-specific and should not be shared.
- When factoring out shared modules, start with the simplest (git config) and work up to complex ones (shell config).
- Platform-conditional expressions (`lib.optionals`, `lib.mkIf`) should be used sparingly — if a module is mostly platform-specific, it's better as a host-specific file than a shared module with lots of conditionals.

## Completion Criteria

- Single flake repo with both `darwinConfigurations.mac-mini` and `nixosConfigurations.macbook-pro`
- Shared Home Manager modules used by both machines
- Both machines build and activate successfully from the same repo
- Changes to shared config (e.g., shell aliases) propagate to both machines on rebuild
- Platform-specific config is cleanly separated
- All changes committed with descriptive conventional commits
