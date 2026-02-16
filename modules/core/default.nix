# Core system configuration shared across all hosts
{ config, lib, pkgs, ... }:

{
  imports = [
    ../nixpkgs.nix
  ];

  # Unfree packages needed across all hosts
  allowedUnfreePackages = [ "claude-code" ];
  # Timezone
  time.timeZone = "Europe/Berlin";

  # Networking
  networking.networkmanager.enable = true;

  # User account
  users.users.yasp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  # Base CLI packages
  environment.systemPackages = with pkgs; [
    claude-code
    git
    neovim
    tree
    vim
    wget
  ];
}
