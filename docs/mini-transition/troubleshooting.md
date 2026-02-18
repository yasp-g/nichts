# Troubleshooting Guide

Common issues encountered during Nix transitions on macOS, organized by phase.

---

## General

### "command not found: nix" in a new terminal
The shell profile isn't sourcing the Nix environment.
```bash
# Check if the hook exists
grep -r "nix" ~/.zshrc ~/.zshenv ~/.zprofile 2>/dev/null

# If missing, the Determinate installer should have added it. Re-source:
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```
If Home Manager later takes over shell config, ensure the Nix hook is preserved.

### Nix commands are very slow
Likely evaluating a large nixpkgs for the first time. Subsequent runs are cached. If persistently slow, check:
```bash
# Is the binary cache reachable?
nix store ping --store https://cache.nixos.org
```

### "error: experimental Nix feature 'flakes' is disabled"
The Determinate installer should enable flakes, but if not:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

---

## Phase 1: Nix Installation

### Installer fails with disk space error
Check available space: `df -h /`. The Nix store needs a dedicated APFS volume. Ensure at least 10GB free.

### "volume creation failed" or APFS volume issues
macOS SIP must be enabled. Check: `csrutil status`. If previously disabled for other reasons, re-enable before installing Nix.

### PATH ordering: Homebrew tools take precedence over Nix
Check your shell profile — if Homebrew's PATH setup runs after the Nix hook, it may prepend itself. This will resolve when Home Manager manages shell config. For now, note it in `reference/decisions.md` and don't manually fix PATH.

---

## Phase 2: Package Migration

### Package behaves differently after migrating from Homebrew to Nix
Version difference. Compare:
```bash
nix eval nixpkgs#<pkg>.version
brew info <pkg>
```
If the Nix version is older/newer and behaves differently, check if `nixpkgs-unstable` or `nixpkgs-stable` has the version you need.

### "nix profile install" starts compiling from source
The package isn't in the binary cache for your architecture. For `aarch64-darwin`:
```bash
nix path-info --store https://cache.nixos.org nixpkgs#<package> 2>&1
```
If not cached, you can: wait for it to build, use `nixpkgs-unstable` (usually has better cache coverage), or keep the Homebrew version.

### Shell completions broke after migration
Completions are installed to a different location by Nix. This will be resolved properly when Home Manager manages shell config in Phase 3. Temporary fix:
```bash
# Find where Nix put the completions
find /nix/store -path "*/<pkg>/share/zsh" 2>/dev/null | head -5
```

---

## Phase 3: Home Manager

### "home-manager switch" fails with collision
Two sources are trying to manage the same file. Common cause: a dotfile exists that Home Manager wants to create.
```bash
# Back up and remove the conflicting file
mv ~/.gitconfig ~/.config-backup/gitconfig.bak
home-manager switch --flake ~/.config/nix-config#yasp
```

### Shell broken after Home Manager takes over .zshrc
**Do not close your working terminal.** Open a new terminal to test. If the new terminal is broken:
```bash
# In your working terminal, roll back:
home-manager generations  # list generations
home-manager switch --flake ~/.config/nix-config#yasp  # after fixing the config

# Or activate the previous generation directly:
/nix/var/nix/profiles/per-user/yasp/home-manager-<N>-link/activate
```

### Home Manager can't find a module
Ensure you're using the right import path and that the module exists in your Home Manager version:
```bash
# Search available options
man home-configuration.nix  # if manpages are enabled
# Or check https://nix-community.github.io/home-manager/options.xhtml
```

### "attribute 'xxx' not found" in home.nix
Usually a typo in a module option name, or the option doesn't exist in your Home Manager version. Use tab completion or check the options reference.

---

## Phase 4: nix-darwin

### First "darwin-rebuild switch" fails
Common issues on first run:
- Conflicting `/etc/nix/nix.conf` — nix-darwin wants to manage this. Back up and let it.
- Conflicting `/etc/shells` — nix-darwin may want to add its managed shell. Let it.
```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-darwin
```

### macOS defaults not taking effect
Some defaults require:
```bash
killall Dock      # Dock settings
killall Finder    # Finder settings
killall SystemUIServer  # Menu bar changes
```
Some require logging out and back in. A few require a full reboot.

### Homebrew cask cleanup removed an app I needed
If `homebrew.onActivation.cleanup = "zap"` removed something:
1. Add the cask name to `homebrew.casks` in your config
2. Rebuild: `darwin-rebuild switch`
3. The app will be reinstalled

**Prevention:** Always start with `cleanup = "none"` and only switch to `"zap"` when your cask list is complete.

### "darwin-rebuild switch" is slow
nix-darwin evaluates the full system config. This is normal for the first build. If subsequent builds are slow, ensure you're using the binary cache:
```bash
nix config show | grep substituters
```

---

## General Recovery

### Rolling back nix-darwin
```bash
darwin-rebuild switch --list-generations
darwin-rebuild switch --rollback  # go back one generation
```

### Rolling back Home Manager
```bash
home-manager generations
home-manager activate <generation-path>
```

### Nuclear option: Uninstall Nix entirely
If everything goes sideways, the Determinate installer provides a clean uninstall:
```bash
/nix/nix-installer uninstall
```
This removes the APFS volume, daemon, and all shell hooks. Your Homebrew and macOS setup remain intact.

---

*Add new issues and solutions as they're encountered.*
