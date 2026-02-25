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

      # Batch 2 — daily-use tools
      chafa
      ffmpeg
      glow
      gnupg
      imagemagick
      # jp2a (broken)
      kubectl
      opencode
      tenv
      trash-cli
      uv
      yazi
    ];
  };
}
