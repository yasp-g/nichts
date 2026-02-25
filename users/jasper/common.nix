# Shared Home Manager configuration across all machines
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Populated during Phase 2 migration
  ];

  programs.home-manager.enable = true;

  # Neovim — full Lua config sourced from repo
  home.sessionVariables.EDITOR = "nvim";
  xdg.configFile."nvim" = {
    source = ./common/nvim;
    recursive = true;
  };

  # Yazi — config files only, plugins managed by yazi's package manager
  xdg.configFile."yazi" = {
    source = ./common/yazi;
    recursive = true;
  };

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
