# Host configuration for Mac Mini M2 Pro (macOS + nix-darwin)
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/nixpkgs.nix
  ];

  # Required for nix-darwin — do not change after initial setup
  system.stateVersion = 6;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Store optimisation (auto-optimise-store corrupts the store on macOS)
  nix.optimise.automatic = true;

  # Automatic garbage collection (weekly, keep 7 days)
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; };
    options = "--delete-older-than 7d";
  };

  # Shell — tell nix-darwin about zsh
  programs.zsh.enable = true;

  # Unfree packages needed on this host
  allowedUnfreePackages = [
    "claude-code"
    "discord"
    "google-chrome"
    "keymapp"
    "obsidian"
    "postman"
    "vscode"
    "zoom"
  ];

  # User account
  system.primaryUser = "jasper";
  users.users.jasper = {
    home = "/Users/jasper";
  };

  # Hostname
  networking.hostName = "mini";

  # System defaults (Dock, Finder, keyboard, etc.) — added incrementally
  # system.defaults = { };

  # Homebrew — only for casks without Nix darwin support
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    brews = [
      "borders"   # Window borders (no nixpkgs equivalent)
      "modular"   # Mojo/MAX toolchain (no nixpkgs equivalent)
    ];
    casks = [
      "calibre"
      "docker"
      "element"
      "freecad"
      "ghostty"
      "gimp"
      "notion"
      "pdfsam-basic"
      "protonvpn"
      "raspberry-pi-imager"
      "sqlectron"
      "steam"
      "teamviewer-host"
      "vnc-viewer"
      "whatsapp"
    ];
  };
}
