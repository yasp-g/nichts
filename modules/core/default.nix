# Core system configuration shared across all hosts
{ config, lib, pkgs, ... }:

{
  imports = [
    ../nixpkgs.nix
  ];

  # Automatic garbage collection (weekly, keep 7 days)
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Unfree packages needed across all hosts
  allowedUnfreePackages = [
    "claude-code"
    "obsidian"
    "vscode"
  ];
  # Timezone
  time.timeZone = "Europe/Berlin";

  # Networking
  networking.networkmanager.enable = true;

  # User account
  users.users.jasper = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  # Base packages (NixOS system-level only; shared packages are in users/jasper/common.nix)
  environment.systemPackages = with pkgs; [
    vim
    wget

    # Nix tooling
    nil
    statix

    # GUI apps
    firefox
    ghostty
  ];
}
