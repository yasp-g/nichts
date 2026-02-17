# Core system configuration shared across all hosts
{ config, lib, pkgs, ... }:

{
  imports = [
    ../nixpkgs.nix
  ];

  # Unfree packages needed across all hosts
  allowedUnfreePackages = [
    "claude-code"
    "obsidian"
  ];
  # Timezone
  time.timeZone = "Europe/Berlin";

  # Networking
  networking.networkmanager.enable = true;

  # User account
  users.users.yasp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  # Base packages
  environment.systemPackages = with pkgs; [
    # CLI utilities
    tmux
    tree
    wget

    # Development
    claude-code
    git
    neovim
    vim

    # Nix tooling
    nil
    statix

    # GUI apps
    firefox
    ghostty
    obsidian
  ];
}
