# Home Manager configuration for jasper (mbp2015 / NixOS)
{ config, pkgs, ... }:

let
  themeData = import ./theme.nix;
  theme = themeData.themes.${themeData.activeTheme};
in
{
  home = {
    username = "jasper";
    homeDirectory = "/home/jasper";
    stateVersion = "25.11"; # Do not change after initial setup

    packages = with pkgs; [
      # Add user-specific packages here
    ];
  };

  # Config files - merge themed modules
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    "hypr/hypridle.conf".source = ./hypr/hypridle.conf;
    "wofi/config".source = ./wofi/config;
  }
  // (import ./hyprlock.nix { inherit theme; })
  // (import ./mako.nix { inherit theme; })
  // (import ./wofi.nix { inherit theme; })
  // (import ./ghostty.nix { inherit theme; });

  # Waybar with systemd service for auto-restart
  programs.waybar = import ./waybar.nix { inherit theme; };

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
