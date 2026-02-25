# Shared Home Manager configuration across all machines
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Populated during Phase 2 migration
  ];

  programs.home-manager.enable = true;
}
