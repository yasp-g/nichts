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
    packages = with pkgs; [
      # System utilities
      vim
      wget             # downloader

      # Nix tooling
      nil              # nix lsp
      statix           # nix linter

      # GUI apps
      breitbandmessung # german speed test
      calibre          # ebook manager
      firefox
      ghostty
      libreoffice
    ];
  };

  # SSH agent — cache key passphrase for the session
  services.ssh-agent.enable = true;

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

  # System-wide dark mode for GTK/Electron apps
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
