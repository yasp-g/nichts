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
      ripgrep
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

      # Batch 3 — dev/specialty tools
      cabal-install
      cmake
      exercism
      git-filter-repo
      haskell-language-server
      stack
      luarocks
      lynx
      pandoc
      wireshark
    ];
  };

  # AeroSpace — macOS-only tiling window manager
  xdg.configFile."aerospace/aerospace.toml".source = ./darwin/aerospace/aerospace.toml;
}
