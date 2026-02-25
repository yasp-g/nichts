# Home Manager configuration for jasper (mbp2015 / NixOS)
{ config, pkgs, ... }:

let
  themeData = import ./common/theme.nix;
  theme = themeData.themes.${themeData.activeTheme};
in
{
  imports = [ ./common.nix ];

  home = {
    username = "jasper";
    homeDirectory = "/home/jasper";
    stateVersion = "25.11"; # Do not change after initial setup
  };

  # Config files - merge themed modules
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
    "hypr/hypridle.conf".source = ./hyprland/hypridle.conf;
    "wallpapers".source = ./hyprland/wallpapers;
    "wofi/config".source = ./hyprland/wofi-config;
  }
  // (import ./hyprland/hyprlock.nix { inherit theme; })
  // (import ./hyprland/mako.nix { inherit theme; })
  // (import ./hyprland/wofi.nix { inherit theme; })
  // (import ./common/ghostty.nix { inherit theme; });

  # Waybar with systemd service for auto-restart
  programs.waybar = import ./hyprland/waybar.nix { inherit theme; };

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
}
