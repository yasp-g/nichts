# Home Manager configuration for yasp
{ config, pkgs, ... }:

{
  home = {
    username = "yasp";
    homeDirectory = "/home/yasp";
    stateVersion = "25.11"; # Do not change after initial setup

    # User packages (not system-wide)
    packages = with pkgs; [
      # Add user-specific packages here
    ];
  };

  # Config files
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
    "ghostty/config".source = ./ghostty/config;
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set number
    '';
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
