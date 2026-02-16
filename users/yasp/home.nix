# Home Manager configuration for yasp
{ config, pkgs, ... }:

{
  home.username = "yasp";
  home.homeDirectory = "/home/yasp";

  # User packages (not system-wide)
  home.packages = with pkgs; [
    # Add user-specific packages here
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Home Manager release version (do not change after initial setup)
  home.stateVersion = "25.11";
}
