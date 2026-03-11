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
      imagemagick      # image manipulation
      kubectl          # kubernetes cli

      # Darwin-only dev/specialty tools
      cabal-install    # haskell build tool
      cmake            # build system
      git-filter-repo  # git history rewriter
      haskell-language-server  # haskell lsp
      stack            # haskell build tool
      lynx             # text browser
      pandoc           # document converter
      wireshark        # network analyzer

      # Darwin-only GUI apps
      aerospace  # Pulled from nixpkgs-unstable via overlay (stable is outdated)
      google-chrome
      grandperspective # disk usage
      ice-bar          # menu bar manager
      postman          # api client
      stats            # system monitor
      zoom-us
    ];
  };

  # AeroSpace — macOS-only tiling window manager
  xdg.configFile."aerospace/aerospace.toml".source = ./darwin/aerospace/aerospace.toml;

  # SSH — macOS-specific option (base config is in common.nix)
  programs.ssh.matchBlocks."*".extraOptions.UseKeychain = "yes";
}
