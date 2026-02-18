# System Inventory

Populated during Phase 0 (2026-02-18). Updated as packages/configs are migrated.

**Machine:** Mac mini (Apple Silicon, arm64)
**macOS:** 26.2
**User:** JasperG (note: different from `yasp` on the MacBook Pro — update nix config accordingly)
**Shell:** `/bin/zsh`

---

## Homebrew Formulas

Only **leaf packages** (not dependencies of anything else) need categorization — deps follow automatically.

**Status key:** KEEP = migrate to Nix | MAYBE = decide later | REMOVE = uninstall | MIGRATED = now in Nix | DEFERRED = staying in Homebrew for now

| Formula | Status | Nix package name | Notes |
|---------|--------|-------------------|-------|
| `aha` | MAYBE | `aha` | Converts ANSI to HTML — niche, low priority |
| `bind` | MAYBE | `bind` | DNS tools (dig, nslookup) — macOS ships `dig`; may not need Homebrew version |
| `boost` | MAYBE | `boost` | C++ library — check if anything actively needs it |
| `cabal-install` | KEEP | `cabal-install` | Haskell package manager — not active now but keeping for future Haskell use |
| `chafa` | KEEP | `chafa` | Terminal image viewer — used by yazi/tools |
| `cmake` | KEEP | `cmake` | Build tool — needed for compiling things |
| `curl` | MAYBE | `curl` | macOS ships curl — may not need Homebrew version |
| `exercism` | MAYBE | `exercism` | Coding practice platform — remove if not active |
| `fastfetch` | KEEP | `fastfetch` | System info display |
| `felixkratz/formulae/borders` | DEFERRED | n/a | Window borders — no nixpkgs equivalent; keep in Homebrew brews |
| `ffmpeg` | KEEP | `ffmpeg` | Media processing |
| `fzf` | KEEP | `fzf` | Fuzzy finder — essential |
| `git` | KEEP | `git` | Essential |
| `git-filter-repo` | MAYBE | `git-filter-repo` | Specialized git history rewriting — remove if rarely used |
| `glow` | KEEP | `glow` | Markdown viewer in terminal |
| `gnupg` | KEEP | `gnupg` | GPG for encryption/signing |
| `hashicorp/tap/terraform` | DEFERRED | n/a | Managed via `tfenv` — see tfenv note below |
| `haskell-language-server` | KEEP | `haskell-language-server` | Not active now but keeping for future Haskell use |
| `haskell-stack` | KEEP | `haskell-stack` | Not active now but keeping for future Haskell use |
| `imagemagick` | KEEP | `imagemagick` | Image manipulation |
| `jp2a` | KEEP | `jp2a` | JPEG to ASCII — used by terminal tools |
| `kubernetes-cli` | KEEP | `kubectl` | kubectl — active use with terraform/infra work |
| `llvm` | MAYBE | `llvm` | Compiler infrastructure — check if anything needs it explicitly |
| `luarocks` | MAYBE | `luarocks` | Lua package manager — used for Neovim plugins; may be replaced by Nix in Phase 3 |
| `lynx` | MAYBE | `lynx` | Text browser — low priority, remove if unused |
| `modularml/packages/modular` | DEFERRED | n/a | Mojo language toolkit — no nixpkgs package; keep in Homebrew or manage manually |
| `neovim` | KEEP | `neovim` | Primary editor |
| `opencode` | KEEP | `opencode` | AI coding tool — also installed as cask; check for duplication |
| `pandoc` | KEEP | `pandoc` | Document converter |
| `powerlevel10k` | DEFERRED | `zsh-powerlevel10k` | Zsh theme — will be managed by Home Manager in Phase 3 |
| `rsync` | KEEP | `rsync` | File sync — macOS ships old rsync; Homebrew/Nix version is newer |
| `tbb` | MAYBE | `tbb` | Intel Threading Building Blocks — likely a dep, check `brew uses tbb` |
| `telnet` | MAYBE | `inetutils` | Network debugging — rarely needed |
| `tfenv` | REMOVE | n/a | Replaced by `tenv` (handles both Terraform and OpenTofu) |
| `tmux` | KEEP | `tmux` | Terminal multiplexer |
| `tofuenv` | REMOVE | n/a | Replaced by `tenv` |
| `trash` | KEEP | `trash-cli` | Safe rm alternative |
| `tree` | KEEP | `tree` | Directory listing |
| `uv` | KEEP | `uv` | Python package/project manager |
| `warrensbox/tap/tfswitch` | REMOVE | n/a | Replaced by `tenv` |
| `tenv` | KEEP | `tenv` | Unified Terraform + OpenTofu version manager — replaces tfenv, tofuenv, tfswitch |
| `wireshark` | MAYBE | `wireshark` | Network analysis — keep if used for debugging |
| `yazi` | KEEP | `yazi` | File manager |
| `zsh-completions` | DEFERRED | n/a | Will be handled by Home Manager `programs.zsh` in Phase 3 |

**Decision:** Consolidating `tfenv`, `tofuenv`, and `tfswitch` → `tenv`. tenv handles both Terraform and OpenTofu and is available in nixpkgs. Migrate in Phase 2.

---

## Homebrew Casks

| Cask | Status | Notes |
|------|--------|-------|
| `aerospace` | KEEP | Window manager — has active config at `~/.config/aerospace/` |
| `claude-code` | KEEP | AI coding assistant |
| `font-meslo-lg-nerd-font` | KEEP | Nerd Font — used in Ghostty/terminal; move to `fonts.packages` in nix-darwin |
| `ghostty` | KEEP | Terminal emulator |
| `jordanbaird-ice` | KEEP | Menu bar manager (Ice.app) |
| `stats` | KEEP | Menu bar system stats |

All 6 casks are KEEP — small, clean list.

---

## Applications (/Applications/)

| Application | Install method | Status | Notes |
|-------------|---------------|--------|-------|
| `Adobe Acrobat DC` | Direct download | MAYBE | Preview handles most PDFs; remove if not specifically needed |
| `AeroSpace.app` | Homebrew Cask | KEEP | Window manager — managed via cask above |
| `AgeClock.app` | Unknown | MAYBE | Decide based on use |
| `Anaconda-Navigator.app` | Direct download | REMOVE | Using `uv` for Python now — Anaconda is heavyweight clutter |
| `Arc.app` | Direct download | KEEP | Browser |
| `Be Focused.app` | Unknown | MAYBE | Pomodoro timer — keep if actively using |
| `calibre.app` | Direct download | MAYBE | Ebook management |
| `DeepL.app` | Direct download | KEEP | Translation tool |
| `Developer.app` | Mac App Store | KEEP | Apple Developer resources |
| `Dia.app` | Direct download | MAYBE | Diagram tool — check if actively used |
| `Discord.app` | Direct download | KEEP | Communication |
| `Disk Inventory X.app` | Direct download | REMOVE | Keeping GrandPerspective instead |
| `DisplayLink Manager.app` | Direct download | KEEP | Required if using DisplayLink dock/monitors |
| `Docker.app` | Direct download | KEEP | Containers |
| `Element.app` | Direct download | MAYBE | Matrix client — keep if using Matrix |
| `Exporter.app` | Unknown | MAYBE | Clarify what this exports |
| `FreeCAD.app` | Direct download | MAYBE | 3D CAD — keep if active use |
| `Ghostty.app` | Homebrew Cask | KEEP | Terminal |
| `GIMP.app` | Direct download | KEEP | Image editor |
| `GitHub Desktop.app` | Direct download | MAYBE | Have git CLI and gh — may be redundant |
| `Google Chrome.app` | Direct download | KEEP | Browser |
| `Grammarly for Safari.app` | Mac App Store | MAYBE | Keep if using Grammarly |
| `GrandPerspective.app` | Direct download | KEEP | Disk visualizer |
| `Hue Sync.app` | Direct download | MAYBE | Philips Hue — keep if have Hue lights |
| `Ice.app` | Homebrew Cask | KEEP | Menu bar manager |
| `JetBrains Toolbox.app` | Direct download | MAYBE | Keep if using JetBrains IDEs |
| `Kindle.app` | Mac App Store | MAYBE | Keep if reading Kindle books |
| `logioptionsplus.app` | Direct download | KEEP | Required for Logitech mouse/keyboard |
| `Microsoft Excel.app` | Mac App Store | KEEP | Office suite |
| `Microsoft PowerPoint.app` | Mac App Store | KEEP | Office suite |
| `Microsoft Teams.app` | Direct download | MAYBE | Keep if required for work |
| `Microsoft To Do.app` | Mac App Store | MAYBE | Have Notion — may be redundant |
| `Microsoft Word.app` | Mac App Store | KEEP | Office suite |
| `Notion Calendar.app` | Direct download | MAYBE | Decide vs other calendar apps |
| `Notion.app` | Direct download | KEEP | Notes/productivity |
| `Numbers.app` | Built-in | KEEP | Built-in |
| `Obsidian.app` | Direct download | KEEP | Notes |
| `OneDrive.app` | Mac App Store | MAYBE | Keep if using OneDrive for storage |
| `OnVUE.app` | Direct download | REMOVE | Online proctoring — exam-specific, can reinstall if needed |
| `OnyX.app` | Direct download | MAYBE | macOS maintenance — rarely needed |
| `Opera.app` | Direct download | MAYBE | Extra browser — probably not needed alongside Arc + Chrome |
| `Pages.app` | Built-in | KEEP | Built-in |
| `PDFsam Basic.app` | Direct download | MAYBE | PDF split/merge — Preview/Acrobat may cover this |
| `Pokemon Reborn` | Direct download | MAYBE | Game — keep if playing |
| `Postman.app` | Direct download | KEEP | API testing |
| `ProtonVPN.app` | Direct download | KEEP | VPN |
| `Python 2.7` | Direct download | REMOVE | Ancient — remove |
| `Python 3.6` | Direct download | REMOVE | Ancient — remove |
| `Python 3.7` | Direct download | REMOVE | Ancient — remove |
| `Python 3.10` | Direct download | REMOVE | Old — using uv; remove |
| `Python 3.11` | Direct download | REMOVE | Old — using uv; remove |
| `Raspberry Pi Imager.app` | Direct download | MAYBE | Keep if working with Pi hardware |
| `Research.app` | Unknown | MAYBE | Identify what this is |
| `Safari.app` | Built-in | KEEP | Built-in |
| `sqlectron.app` | Direct download | MAYBE | SQL client — keep if actively used |
| `Stats.app` | Homebrew Cask | KEEP | Menu bar stats |
| `Steam.app` | Direct download | KEEP | Gaming |
| `TeamViewerHost.app` | Direct download | MAYBE | Remote access — keep if needed |
| `VNC Viewer.app` | Direct download | MAYBE | Remote desktop |
| `Visual Studio Code.app` | Direct download | KEEP | Keeping alongside Zed and Neovim for now |
| `WD Discovery` | Direct download | MAYBE | Keep if using WD external drives |
| `WD Drive Utilities.app` | Direct download | MAYBE | Keep if using WD external drives |
| `WD Drive Utilities Uninstaller.app` | Direct download | REMOVE | Uninstaller utility — remove after WD decision |
| `WhatsApp.app` | Direct download | KEEP | Messaging |
| `Xcode.app` | Mac App Store | KEEP | Required for macOS development |
| `Zed.app` | Direct download | KEEP | Editor — actively configured |
| `zoom.us.app` | Direct download | KEEP | Video calls |

**Clear REMOVEs:** Anaconda-Navigator, Disk Inventory X, OnVUE, Python 2.7/3.6/3.7/3.10/3.11, WD Drive Utilities Uninstaller

---

## Dotfiles & Config

**Status key:** UNMANAGED = manual | HM_MODULE = Home Manager module | HM_FILE = Home Manager xdg/home.file | SKIPPED = not migrating

| Config file/dir | Application | HM module? | Status | Notes |
|----------------|-------------|------------|--------|-------|
| `~/.gitconfig` | Git | `programs.git` | UNMANAGED | Has LFS config, nbdiff drivers — preserve these |
| `~/.p10k.zsh` | Powerlevel10k | — | UNMANAGED | Prompt config — use `home.file` or `programs.zsh.initExtra` |
| `~/.zshrc` | Zsh | `programs.zsh` | UNMANAGED | Has NVM, tfenv, modular, FZF, p10k — complex |
| `~/.zprofile` | Zsh | — | UNMANAGED | Only Q pre/post blocks — likely safe to ignore |
| `~/.ssh/` | SSH | `programs.ssh` | UNMANAGED | Contains keys — manage config only, never commit keys |
| `~/.config/nvim/` | Neovim | `programs.neovim` | UNMANAGED | Has `init.lua`, `lua/`, `lazy-lock.json` — use `xdg.configFile` |
| `~/.config/yazi/` | Yazi | `programs.yazi` | UNMANAGED | Has `init.lua`, `package.toml`, `plugins/` |
| `~/.config/aerospace/` | AeroSpace | — | UNMANAGED | `aerospace.toml` — use `xdg.configFile` |
| `~/.config/git/` | Git | `programs.git` | UNMANAGED | Git attributes file — merge with `.gitconfig` in HM |
| `~/.config/zed/` | Zed | — | UNMANAGED | `settings.json` — use `xdg.configFile` |
| `~/.config/gh/` | GitHub CLI | `programs.gh` | UNMANAGED | gh config + auth — manage config, not tokens |
| `~/.config/opencode/` | opencode | — | UNMANAGED | AI tool config |
| `~/.config/fish/` | Fish | `programs.fish` | UNMANAGED | Fish shell config exists — not primary shell (zsh is) |
| `~/.config/kitty/` | Kitty | `programs.kitty` | UNMANAGED | Old terminal config — using Ghostty now; SKIP |
| `~/.config/nvim/` | Neovim | — | UNMANAGED | — |
| `~/.config/exercism/` | Exercism | — | UNMANAGED | Exercism CLI config |
| `~/.nvm/` | NVM | — | UNMANAGED | Node version manager — replace with Nix in Phase 3 |
| `~/.gemini_aliases` | Gemini tools | — | SKIPPED | Removed 2026-02-18 — no longer used, no API keys |

**Flags:**
- `~/.nvm/` — NVM is not Nix-native; Phase 3 will replace with `programs.node` or shell-managed nix devShells

---

## macOS Defaults (Observed)

| Setting | Domain/Key | Current value | Manage via nix-darwin? | Notes |
|---------|-----------|---------------|----------------------|-------|
| Dock autohide | `com.apple.dock autohide` | `1` (on) | Yes | |
| Dock orientation | `com.apple.dock orientation` | `bottom` | Yes | |
| Dock show-recents | `com.apple.dock show-recents` | `1` (on) | Yes | |
| Finder show extensions | `com.apple.finder AppleShowAllExtensions` | `1` (on) | Yes | |
| Finder path bar | `com.apple.finder ShowPathbar` | `1` (on) | Yes | |
| Finder status bar | `com.apple.finder ShowStatusBar` | `1` (on) | Yes | |
| Key repeat rate | `NSGlobalDomain KeyRepeat` | not set (system default) | Yes | Set explicitly in Phase 4 |
| Initial key repeat | `NSGlobalDomain InitialKeyRepeat` | not set (system default) | Yes | Set explicitly in Phase 4 |

---

## Shell Environment

- **Shell:** `/bin/zsh` (system zsh)
- **Shell framework:** None (no oh-my-zsh)
- **Prompt:** Powerlevel10k
- **Key aliases:** only shell defaults (`run-help=man`, `which-command=whence`) — no custom aliases yet
- **Key env vars:**
  - `MODULAR_HOME=$HOME/.modular` (Mojo language)
  - `NVM_DIR=$HOME/.nvm` (Node version manager)
  - `HOMEBREW_PREFIX=/opt/homebrew`
- **PATH entries to preserve:**
  - `$HOME/.tfenv/bin` (Terraform version manager)
  - `$HOME/.luarocks/bin` (Lua packages)
  - `$MODULAR_HOME/pkg/packages.modular.com_mojo/bin` (Mojo)
  - NVM path (added dynamically by nvm.sh)
- **Shell plugins:** FZF integration (`fzf --zsh`), Zsh completions via Homebrew
- **Sourced files:** `~/.p10k.zsh`, `~/.gemini_aliases` (if exists), NVM scripts

---

## Disk Usage Baseline

```
Date: 2026-02-18
Total disk: 460 GiB
Used: 15 GiB
Available: 36 GiB
Capacity: 30%
~/Desktop: 1.6 GB
~/Documents: 48 GB
~/Downloads: 825 MB
~/Library: 82 GB
~/Movies: 376 MB
~/Music: 19 GB
~/Pictures: 19 GB
~/Library/Caches: 12 GB
/nix/store: N/A (pre-install)
```

**Note:** Library/Caches at 12 GB — worth running `brew cleanup --prune=all` before Phase 1 to reclaim space.
