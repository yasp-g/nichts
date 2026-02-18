# Phase 3: Set Up Home Manager

**Status:** `NOT_STARTED`
**Prerequisites:** Phase 1 complete (Phase 2 can be in progress)
**Estimated time:** 3–5 sessions
**Outcome:** Dotfiles and user-level packages managed declaratively via Home Manager

## Overview

Home Manager replaces your manually maintained dotfiles with Nix expressions that generate and symlink config files. This is the biggest mental model shift in the whole transition: you stop editing dotfiles directly and instead edit `.nix` files that produce dotfiles.

## Setup Checklist

### Add Home Manager to the Flake

- [ ] Edit `~/.config/nix-config/flake.nix` to add Home Manager as an input:
  ```nix
  {
    description = "Yasp's multi-machine Nix configuration";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."yasp" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  }
  ```
- [ ] Create `home.nix` with a minimal starting config:
  ```nix
  { config, pkgs, ... }:

  {
    home.username = "yasp";  # adjust to actual username
    home.homeDirectory = "/Users/yasp";  # adjust to actual home dir
    home.stateVersion = "24.11";  # set to current stable version at time of setup

    programs.home-manager.enable = true;
  }
  ```
- [ ] Run `nix flake update` to fetch Home Manager
- [ ] Build and activate: `nix run home-manager -- switch --flake ~/.config/nix-config#yasp`
- [ ] Verify it worked: `home-manager --version`
- [ ] Commit: `git add -A && git commit -m "feat: add home-manager with minimal config"`

### Migrate Packages from nix profile to Home Manager

If you installed packages imperatively in Phase 2, move them to Home Manager:

- [ ] Add packages to `home.nix`:
  ```nix
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    # ... add your packages from Phase 2
  ];
  ```
- [ ] Rebuild: `home-manager switch --flake ~/.config/nix-config#yasp`
- [ ] Verify packages still work
- [ ] Remove imperative installations: `nix profile remove <index>` for each
- [ ] Verify packages still work after removing from profile (Home Manager now provides them)
- [ ] Commit

## Dotfile Migration — One Config at a Time

### Order of Migration (recommended, low-risk to high-risk)

1. **Git config** (`~/.gitconfig`) — Simple, low risk, has a great HM module
2. **Starship / shell prompt** — If applicable
3. **Editor config** — Your editor of choice
4. **SSH config** (`~/.ssh/config`) — Be careful with keys and secrets
5. **Shell config** (`~/.zshrc`) — Most complex, do last

### For Each Config File

**Before migrating:**
- [ ] Back up the original: `cp <config-file> ~/.config-backup/`
- [ ] Check if Home Manager has a dedicated module: search https://nix-community.github.io/home-manager/options.xhtml

**Option A: Use a Home Manager module (preferred when available)**
```nix
# Example: Git
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "your@email.com";
  extraConfig = {
    init.defaultBranch = "main";
    push.autoSetupRemote = true;
    # ... other settings from your current .gitconfig
  };
};
```

**Option B: Use raw file management (for configs without HM modules)**
```nix
# Place a file at ~/.config/some-app/config
xdg.configFile."some-app/config".text = ''
  # config contents here
'';

# Or source from a file in your repo
xdg.configFile."some-app/config".source = ./configs/some-app-config;
```

**After migrating each file:**
- [ ] Rebuild: `home-manager switch --flake ~/.config/nix-config#yasp`
- [ ] Verify the generated file is correct: `cat <config-file>` and compare to backup
- [ ] Verify the application works with the new config
- [ ] Commit: `git commit -m "feat(home): manage <app> config via home-manager"`

### Migration Template

| Config | HM Module? | Migrated | Verified | Committed |
|--------|-----------|----------|----------|-----------|
| `.gitconfig` | `programs.git` | ☐ | ☐ | ☐ |
| shell prompt | varies | ☐ | ☐ | ☐ |
| editor config | varies | ☐ | ☐ | ☐ |
| `.ssh/config` | `programs.ssh` | ☐ | ☐ | ☐ |
| `.zshrc` | `programs.zsh` | ☐ | ☐ | ☐ |
| | | ☐ | ☐ | ☐ |

## Shell Config Migration (Detailed — Do This Last)

Shell config is the most delicate migration because a broken shell config means a broken terminal.

- [ ] Review current `.zshrc` thoroughly — note every section
- [ ] Identify: aliases, functions, PATH modifications, sourced files, plugin managers, prompt config, completions
- [ ] Migrate to `programs.zsh`:
  ```nix
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      # ... your aliases
    };

    initExtra = ''
      # Anything that doesn't have a dedicated HM option
      # goes here as raw shell script
    '';

    # If you use oh-my-zsh:
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "git" "docker" ];
    #   theme = "robbyrussell";
    # };
  };
  ```
- [ ] **Critical:** Ensure the Nix shell hook is preserved. Home Manager usually handles this, but verify after rebuild that `nix` commands still work.
- [ ] Test in a new terminal — do NOT close your current terminal until the new one works
- [ ] Verify: PATH is correct, aliases work, completions work, prompt renders correctly

## Handling Secrets

Secrets (API keys, tokens, etc.) must NOT go into your Nix config (which is tracked in Git).

**Approaches, from simplest to most robust:**

1. **Environment file sourced by shell config:**
   ```nix
   programs.zsh.initExtra = ''
     [ -f ~/.secrets ] && source ~/.secrets
   '';
   ```
   Keep `~/.secrets` untracked and manually managed.

2. **agenix or sops-nix:** Encrypted secrets stored in Git, decrypted at activation time.
   More complex but fully declarative. Consider this for Phase 5 if needed.

3. **macOS Keychain:** For some applications, secrets can stay in the system keychain.
   Not managed by Nix, but doesn't need to be.

- [ ] Decide on secrets approach (log in `reference/decisions.md`)
- [ ] Migrate secrets out of any dotfiles before those dotfiles are committed to the Nix config repo

## Shared Config with NixOS Machine

Home Manager works identically on NixOS and macOS. Start thinking about what can be shared:

- [ ] Identify configs that are identical across machines (git, editor, shell aliases)
- [ ] Identify configs that are machine-specific (paths, hardware-specific settings)
- [ ] Plan directory structure for shared vs. machine-specific modules:
  ```
  nix-config/
  ├── flake.nix
  ├── home.nix              # Mac mini specific
  ├── modules/
  │   └── home/
  │       ├── git.nix        # shared
  │       ├── shell.nix      # shared
  │       └── editor.nix     # shared
  └── hosts/
      ├── mac-mini/
      └── macbook-pro/       # NixOS config, added later
  ```
- [ ] Don't restructure yet — just plan. Actual consolidation is Phase 5.

## Notes for Claude Code Agent

- **Always back up before overwriting any dotfile.** Use `~/.config-backup/<filename>` as the backup location.
- **Do not migrate all dotfiles at once.** One at a time, verify, commit, then proceed.
- **If a rebuild fails**, the previous generation is still active. Help the user debug the Nix expression rather than reverting.
- **When writing Nix expressions**, prefer Home Manager modules over raw file management — they handle edge cases and are more maintainable.
- **Shell config is the highest-risk migration.** Always keep the current terminal open while testing shell changes in a new terminal.
- **Check `home-manager news`** after updates for relevant changes.
- After each dotfile migration, verify the application loads the config correctly and behaviors match the previous setup.

## Completion Criteria

- Home Manager is installed and functional via the flake
- All user-level packages are declared in `home.nix` (not in `nix profile`)
- All target dotfiles are managed by Home Manager
- Shell config works correctly with proper PATH, aliases, completions, and prompt
- Secrets are handled safely (not committed to Git)
- All changes committed with descriptive conventional commits
- No regressions in daily workflow
