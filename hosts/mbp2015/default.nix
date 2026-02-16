# Host configuration for MacBook Pro 2015 (Intel)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/desktop/hyprland.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Hostname
  networking.hostName = "mbp2015";

  # Broadcom WiFi (requires unfree drivers)
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # Hardware-specific unfree/insecure packages
  allowedUnfreePackages = [ "broadcom-sta" ];
  allowedInsecurePackages = [ "broadcom-sta-6.30.223.271-59-6.12.70" ];

  # NixOS release version (do not change after install)
  system.stateVersion = "25.11";
}
