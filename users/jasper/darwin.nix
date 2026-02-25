# Home Manager configuration for jasper (macOS / Darwin)
{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  home = {
    username = "jasper";
    homeDirectory = "/Users/jasper";
    stateVersion = "25.11"; # Do not change after initial setup

    packages = with pkgs; [
      # Batch 1 — essentials
      git
      neovim
      fzf
      tree
      tmux
      rsync
      fastfetch
    ];
  };
}
