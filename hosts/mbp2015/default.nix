# Host configuration for MacBook Pro 2015 (Intel)
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos
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

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Broadcom WiFi (requires unfree drivers)
  hardware.enableRedistributableFirmware = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Hardware-specific unfree/insecure packages
  allowedUnfreePackages = [ "broadcom-sta" "breitbandmessung" ];
  allowedInsecurePackages = [ "broadcom-sta" ];  # prefix-matched, survives kernel updates

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    blueman        # Bluetooth manager GUI
    brightnessctl  # laptop brightness
  ];

  # NixOS release version (do not change after install)
  system.stateVersion = "25.11";
}
