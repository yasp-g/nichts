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
    brightnessctl   # laptop brightness
    claude-code     # AI coding assistant
    firefox         # browser
    ghostty         # terminal emulator
    git
    neovim
    obsidian        # markdown notes
    tmux
    tree
    vim
    wget
  ];
}
