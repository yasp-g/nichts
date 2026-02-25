# Shared Home Manager configuration across all machines
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Populated during Phase 2 migration
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "yasp-g";
      user.email = "jasper@yasp.studio";
      init.defaultBranch = "main";
      core.autocrlf = "input";
    };
  };
}
