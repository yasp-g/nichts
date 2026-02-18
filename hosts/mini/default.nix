# Host configuration for Mac Mini M2 Pro (macOS + nix-darwin)
# TODO: Build this out in Phase 6
{ config, lib, pkgs, ... }:

{
  # System defaults (Dock, Finder, keyboard, etc.)
  # system.defaults = { };

  # Host-specific packages
  # environment.systemPackages = with pkgs; [ ];

  # Required for nix-darwin
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your hostname
  networking.hostName = "mini";
}
