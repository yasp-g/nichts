# Hyprland desktop environment
{ config, lib, pkgs, ... }:

{
  # Hyprland compositor
  programs.hyprland.enable = true;

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Audio via PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # OpenGL for Hyprland
  hardware.graphics.enable = true;

  # Hyprland packages
  environment.systemPackages = with pkgs; [
    grim               # screenshot
    hyprlock           # screen locking
    mako               # notifications
    networkmanagerapplet
    slurp              # region selection
    waybar             # status bar
    wl-clipboard       # clipboard
    wofi               # app launcher
  ];
}
