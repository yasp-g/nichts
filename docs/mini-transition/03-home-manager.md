# Phase 3: Migrate Dotfiles & Shell Config

**Status:** `DONE`
**Prerequisites:** Phase 2 complete (Home Manager running, packages migrated)
**Estimated time:** 3–5 sessions
**Outcome:** Dotfiles and shell configuration managed declaratively via Home Manager

## Overview

Home Manager is already running from Phase 2, managing your packages. This phase adds dotfile and shell config management on top of that. This is the biggest mental model shift: you stop editing dotfiles directly and instead edit `.nix` files that produce dotfiles.

**This is the highest-risk phase.** A broken shell config means a broken terminal. Go slowly, one config at a time, and always keep a working terminal open while testing.

## Dotfile Migration — One Config at a Time

### Step 0: Fix PATH ordering (URGENT)

After Phase 2, `~/.nix-profile/bin` comes after `/opt/homebrew/bin` in PATH. This causes tmux's `run-shell` (used by TPM, resurrect, continuum) to fail with `tmux: command not found` (exit 127). Fixing `programs.zsh` or `set-environment -g PATH` in tmux config will resolve this. **Do this first.**

**CLEANUP REQUIRED:** A temporary `set-environment -g PATH` hack was added to `~/.tmux.conf` (top of file) to work around this. It MUST be removed once PATH is fixed properly here. Search for `TODO(phase-3)` in `~/.tmux.conf`.

### Order of Migration (low-risk to high-risk)

1. **Git config** (`~/.gitconfig`) — Simple, low risk, great HM module
2. **SSH config** (`~/.ssh/config`) — Manage config only, never commit keys
3. **Yazi config** (`~/.config/yazi/`) — HM module available
4. **Neovim config** (`~/.config/nvim/`) — Complex but self-contained
5. **Other app configs** (Zed, AeroSpace, etc.) — Use `xdg.configFile`
6. **Shell config** (`~/.zshrc`, `~/.p10k.zsh`) — Most complex, do last

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
  lfs.enable = true;
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
- [ ] Rebuild: `home-manager switch --flake ~/.config/nix-config#jasper`
- [ ] Verify the generated file is correct: compare to backup
- [ ] Verify the application works with the new config
- [ ] Commit: `feat(home): manage <app> config via home-manager`

### Migration Checklist

| Config | HM Module? | Backed up | Migrated | Verified | Committed |
|--------|-----------|-----------|----------|----------|-----------|
| `.gitconfig` | `programs.git` | ☑ | ☑ | ☑ | ☐ |
| `.ssh/config` | `programs.ssh` | ☑ | ☑ | ☑ | ☐ |
| `~/.config/yazi/` | `xdg.configFile` | ☑ | ☑ | ☑ | ☐ |
| `~/.config/nvim/` | `xdg.configFile` | ☑ | ☑ | ☑ | ☐ |
| `~/.config/aerospace/` | `xdg.configFile` | ☑ | ☑ | ☑ | ☐ |
| `~/.config/zed/` | `xdg.configFile` | ☑ | ☑ | ☑ | ☐ |
| `~/.config/gh/` | `xdg.configFile` | ☑ | ☑ | ☑ | ☐ |
| `.zshrc` / `.p10k.zsh` | `programs.zsh` | ☑ | ☑ | ☑ | ☐ |

## Shell Config Migration (Do This Last)

Shell config is the most delicate because a broken shell config means a broken terminal.

- [ ] Review current `.zshrc` thoroughly — note every section
- [ ] Identify: aliases, functions, PATH modifications, sourced files, prompt config, completions
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
  };
  ```
- [ ] **Critical:** Ensure the Nix shell hook is preserved. Home Manager usually handles this, but verify after rebuild that `nix` commands still work.
- [ ] Test in a **new terminal** — do NOT close your current terminal until the new one works
- [ ] Verify: PATH is correct, aliases work, completions work, prompt renders correctly

### Shell-Adjacent Decisions

These need to be resolved during shell migration:

- **NVM** (`~/.nvm/`) — Replace with `programs.node` or Nix devShells? Log decision.
- **Powerlevel10k** — Use HM's `zsh-powerlevel10k` package + source `~/.p10k.zsh`
- **FZF integration** — Use `programs.fzf.enable = true` (HM handles shell integration)
- **zsh-completions** — Use `programs.zsh.enableCompletion` (HM handles this)
- **Luarocks PATH** — Keep in `initExtra` or replace with Nix-managed Lua?
- **Modular/Mojo PATH** — Keep in `initExtra` (no Nix equivalent)

## Handling Secrets

Secrets (API keys, tokens, etc.) must NOT go into your Nix config (tracked in Git).

**Approaches, from simplest to most robust:**

1. **Environment file sourced by shell config:**
   ```nix
   programs.zsh.initExtra = ''
     [ -f ~/.secrets ] && source ~/.secrets
   '';
   ```
   Keep `~/.secrets` untracked and manually managed.

2. **agenix or sops-nix:** Encrypted secrets stored in Git, decrypted at activation time.
   More complex but fully declarative. Consider for Phase 5 if needed.

3. **macOS Keychain:** For some applications, secrets can stay in the system keychain.

- [ ] Decide on secrets approach (log in `reference/decisions.md`)
- [ ] Migrate secrets out of any dotfiles before those dotfiles are committed to the Nix config repo

## Shared Config Planning

Home Manager works identically on NixOS and macOS. Start identifying what can be shared:

- [ ] Identify configs that are identical across machines (git, editor, shell aliases)
- [ ] Identify configs that are machine-specific (paths, hardware-specific settings)
- [ ] Plan module structure for shared vs. machine-specific config
- [ ] Don't restructure yet — just plan. Actual consolidation is Phase 5.

## Notes for Claude Code Agent

- **Always back up before overwriting any dotfile.** Use `~/.config-backup/<filename>`.
- **Do not migrate all dotfiles at once.** One at a time, verify, commit, proceed.
- **If a rebuild fails**, the previous generation is still active. Debug the Nix expression.
- **Prefer Home Manager modules** over raw file management — they handle edge cases.
- **Shell config is the highest-risk migration.** Always keep the current terminal open while testing in a new terminal.
- **Check `home-manager news`** after updates for relevant changes.
- After each dotfile migration, verify the application loads the config correctly and behaviors match the previous setup.

## Completion Criteria

- All target dotfiles are managed by Home Manager
- Shell config works correctly with proper PATH, aliases, completions, and prompt
- Secrets are handled safely (not committed to Git)
- All changes committed with descriptive conventional commits
- No regressions in daily workflow
