# Phase 5: Multi-Machine Consolidation

**Status:** `NOT_STARTED`
**Prerequisites:** Phase 4 complete, NixOS MacBook Pro config available
**Estimated time:** 3–5 sessions
**Outcome:** Single flake repo managing both machines with shared modules

## Overview

This phase brings your NixOS MacBook Pro config into the same flake as your Mac mini's nix-darwin config. Shared Home Manager modules (git, shell, editor) are factored out so both machines stay consistent. Machine-specific config stays in separate host directories.

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

Your MacBook Pro currently uses channels. To bring it into the shared flake:

- [ ] Copy current NixOS config files into `hosts/macbook-pro/` in the shared repo
- [ ] Adapt them to work as flake modules (remove channel references, use `inputs.nixpkgs`)
- [ ] Add `nixosConfigurations.macbook-pro` to `flake.nix`:
  ```nix
  nixosConfigurations."macbook-pro" = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";  # Intel MacBook Pro
    modules = [
      ./hosts/macbook-pro/configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.yasp = import ./hosts/macbook-pro/home.nix;
      }
    ];
  };
  ```
- [ ] Test on the MacBook Pro: `sudo nixos-rebuild switch --flake .#macbook-pro`
- [ ] Verify everything works identically to the channel-based setup
- [ ] Commit

### Factor Out Shared Home Manager Modules

- [ ] Identify Home Manager config that's identical on both machines
- [ ] Extract into `modules/home/`:
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
