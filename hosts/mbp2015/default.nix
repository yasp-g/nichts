# Host configuration for MacBook Pro 2015 (Intel)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/desktop/hyprland.nix
  ];

  # Boot loader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    # Broadcom WiFi
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  networking.hostName = "mbp2015";

  # Broadcom WiFi (requires unfree drivers)
  hardware.enableRedistributableFirmware = true;

  # Hardware-specific unfree/insecure packages
  allowedUnfreePackages = [ "broadcom-sta" ];
  allowedInsecurePackages = [ "broadcom-sta-6.30.223.271-59-6.12.70" ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    brightnessctl  # laptop brightness
  ];

  # NixOS release version (do not change after install)
  system.stateVersion = "25.11";
}
