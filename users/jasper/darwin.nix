# Home Manager configuration for jasper (macOS / Darwin)
{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  home = {
    username = "jasper";
    homeDirectory = "/Users/jasper";
    stateVersion = "25.11"; # Do not change after initial setup

    # Homebrew binaries (borders, modular, etc.)
    sessionPath = [ "/opt/homebrew/bin" ];

    packages = with pkgs; [
      # Darwin-only daily tools
      imagemagick
      kubectl

      # Darwin-only dev/specialty tools
      cabal-install
      cmake
      git-filter-repo
      haskell-language-server
      stack
      lynx
      pandoc
      wireshark

      # Darwin-only GUI apps
      aerospace
      google-chrome
      grandperspective
      ice-bar
      postman
      stats
      zoom-us
    ];
  };

  # AeroSpace — macOS-only tiling window manager
  xdg.configFile."aerospace/aerospace.toml".source = ./darwin/aerospace/aerospace.toml;
}
