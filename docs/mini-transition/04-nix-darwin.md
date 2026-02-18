# Phase 4: Introduce nix-darwin

**Status:** `NOT_STARTED`
**Prerequisites:** Phase 1 and Phase 3 complete
**Estimated time:** 2–4 sessions
**Outcome:** System-level macOS config managed declaratively via nix-darwin, with Home Manager integrated as a module

## Overview

nix-darwin is the macOS equivalent of NixOS's `configuration.nix`. It manages system-level settings: macOS defaults, launch daemons, Homebrew Cask installations, system environment, and fonts. After this phase, running `darwin-rebuild switch` configures both the system and your user environment in one command.

## Setup Checklist

### Add nix-darwin to the Flake

- [ ] Edit `~/.config/nix-config/flake.nix`:
  ```nix
  {
    description = "Yasp's multi-machine Nix configuration";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
    in {
      darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./hosts/mac-mini/configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yasp = import ./home.nix;  # adjust username
          }
        ];
      };
    };
  }
  ```

### Create the darwin Configuration

- [ ] Create `hosts/mac-mini/configuration.nix`:
  ```nix
  { config, pkgs, ... }:

  {
    # Required for nix-darwin
    system.stateVersion = 5;  # check nix-darwin docs for current version

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # System-level packages (available to all users)
    environment.systemPackages = with pkgs; [
      # minimal set — most packages should be in Home Manager
    ];

    # Enable Nix daemon (should already be running)
    services.nix-daemon.enable = true;

    # Shell — tell nix-darwin about your shell
    programs.zsh.enable = true;

    # Placeholder for macOS defaults (added incrementally below)
    # system.defaults = { };

    # Placeholder for Homebrew Cask management (added below)
    # homebrew = { };
  }
  ```

### First Build

- [ ] `nix flake update`
- [ ] Build and activate:
  ```bash
  nix run nix-darwin -- switch --flake ~/.config/nix-config#mac-mini
  ```
  (On first run, nix-darwin bootstraps itself. Subsequent runs use `darwin-rebuild switch`.)
- [ ] Verify it worked: `darwin-rebuild --version`
- [ ] Verify Home Manager still works (it's now integrated as a module)
- [ ] Verify all your tools and configs still work
- [ ] Commit: `git commit -m "feat: add nix-darwin with home-manager integration"`

### Update the Rebuild Command

From now on, use one command for everything:
```bash
darwin-rebuild switch --flake ~/.config/nix-config#mac-mini
```

This applies both system-level (nix-darwin) and user-level (Home Manager) changes.

## Manage Homebrew Cask Declaratively

nix-darwin has a `homebrew` module that manages Cask installations. This is the cleanest way to handle macOS GUI apps.

- [ ] Enable the Homebrew module:
  ```nix
  # In hosts/mac-mini/configuration.nix
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # remove anything not declared here
      # Start with "none" until you're confident in your list:
      # cleanup = "none";
    };

    casks = [
      # Move your KEEP casks from the audit here, e.g.:
      # "firefox"
      # "1password"
      # "iterm2"
      # "discord"
    ];

    # If you still need any Homebrew formulas (rare at this point):
    brews = [
      # "some-formula-not-in-nixpkgs"
    ];

    # Tap additional repos if needed:
    # taps = [
    #   "homebrew/cask-fonts"
    # ];
  };
  ```

- [ ] **Start with `cleanup = "none"`** — this prevents nix-darwin from removing casks you forgot to list
- [ ] Add all your KEEP casks from Phase 0 inventory
- [ ] Rebuild: `darwin-rebuild switch --flake ~/.config/nix-config#mac-mini`
- [ ] Verify all GUI apps still work
- [ ] Once confident the list is complete, switch to `cleanup = "zap"` to remove unlisted casks
- [ ] Commit

**Warning:** `cleanup = "zap"` will remove any Homebrew cask not in your declaration. Make sure your list is complete first.

## Manage macOS Defaults

Add macOS preferences incrementally. Do a few at a time, rebuild, verify.

- [ ] Start with low-risk, easily visible settings:
  ```nix
  system.defaults = {
    dock = {
      autohide = true;          # or false — your preference
      orientation = "bottom";    # "left", "bottom", "right"
      show-recents = false;
      # tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";  # list view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;     # adjust to your preference
      KeyRepeat = 2;             # adjust to your preference
      # "com.apple.swipescrolldirection" = true;  # natural scrolling
    };

    # trackpad = {
    #   Clicking = true;  # tap to click
    #   TrackpadRightClick = true;
    # };
  };
  ```
- [ ] Rebuild: `darwin-rebuild switch --flake ~/.config/nix-config#mac-mini`
- [ ] **Some settings require logging out and back in, or restarting the Dock:**
  ```bash
  killall Dock    # applies Dock changes
  killall Finder  # applies Finder changes
  ```
- [ ] Verify each setting took effect in System Settings
- [ ] Add more settings in subsequent commits as desired
- [ ] Reference the macOS defaults audit from Phase 0

### Finding the Right Default Keys

macOS defaults are poorly documented. Useful techniques:
```bash
# Read current value of a specific default
defaults read com.apple.dock autohide

# Diff defaults before and after changing a setting in System Settings
defaults read > /tmp/before.txt
# (change the setting in System Settings)
defaults read > /tmp/after.txt
diff /tmp/before.txt /tmp/after.txt
```

Check nix-darwin options: https://daiderd.com/nix-darwin/manual/index.html

## Manage Fonts (Optional)

- [ ] If you use custom fonts, declare them:
  ```nix
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # etc.
  ];
  ```
- [ ] Rebuild and verify fonts appear in Font Book

## Manage System Services (Optional, Advanced)

nix-darwin can manage launchd services. Only use this if you have specific services to manage:
```nix
launchd.user.agents.my-service = {
  serviceConfig = {
    ProgramArguments = [ "/path/to/binary" ];
    KeepAlive = true;
    RunAtLoad = true;
  };
};
```

## Remove Standalone Home Manager

Since Home Manager is now integrated as a nix-darwin module, clean up the standalone installation:

- [ ] Remove the standalone `homeConfigurations` output from `flake.nix` (if still present)
- [ ] Verify `darwin-rebuild switch` still manages Home Manager correctly
- [ ] Commit

## Notes for Claude Code Agent

- The first `nix-darwin` build requires bootstrapping — use `nix run nix-darwin -- switch`, not `darwin-rebuild switch`.
- **Start Homebrew cleanup as "none"** until the cask list is confirmed complete. Switching to "zap" prematurely will uninstall apps the user forgot to list.
- macOS defaults are finicky. Apply them in small batches so it's clear which setting caused any issue.
- Some `system.defaults` options require logout/reboot. Always warn the user before applying defaults that might disrupt their session.
- If `darwin-rebuild switch` fails, the previous generation is still active. Debug the Nix expression.
- The `nix-darwin` options search at https://daiderd.com/nix-darwin/manual/index.html is the definitive reference.
- When adding casks, match the exact Homebrew cask name (e.g., `"visual-studio-code"` not `"vscode"`).

## Completion Criteria

- `darwin-rebuild switch` works and manages both system and user config
- GUI apps managed declaratively via `homebrew.casks`
- macOS defaults for key preferences are declared and applied
- Home Manager is integrated as a nix-darwin module (not standalone)
- Homebrew only contains what nix-darwin tells it to
- All changes committed with descriptive conventional commits
- No regressions in daily workflow
