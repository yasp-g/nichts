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
    "keymapp"
  ];

  # User account
  users.users.jasper = {
    home = "/Users/jasper";
  };

  # Hostname
  networking.hostName = "mini";

  # System defaults (Dock, Finder, keyboard, etc.) — added incrementally
  # system.defaults = { };

  # Homebrew Cask management — added after bootstrap is verified
  # homebrew = { };
}
